//
//  CalroriesMainTableViewController.swift
//  Tracker
//
//  Created by Nick Nguyen on 3/27/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import UIKit
import CoreData

class CalroriesMainTableViewController: UITableViewController {

    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let context = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
        
    }()
    
    
    
    
    private let calorieController = CalorieController()
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Calorie Tracker"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    
    
    
    //MARK:- Action
    
    @objc func addTapped() {
        showAlert()
    }
    
    
    
    func showAlert() {
        let ac = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        ac.addTextField { (textField) in
            textField.placeholder = "Enter amount of calories"
            textField.keyboardType = .numberPad
        }
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }


}

extension CalroriesMainTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         tableView.beginUpdates()
     }
     
     func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         tableView.endUpdates()
     }
     
     func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
         switch type {
             case .insert:
                 tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
             case .delete:
                 tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
             default:
                 break
         }
     }
     
     func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
         switch type {
             case .insert:
                 guard let newIndexPath = newIndexPath else { return }
                 tableView.insertRows(at: [newIndexPath], with: .automatic)
             case .update:
                 guard let indexPath = indexPath else { return }
                 tableView.reloadRows(at: [indexPath], with: .automatic)
             case .move:
                 guard let oldIndexPath = indexPath,
                     let newIndexPath = newIndexPath else { return }
                 tableView.deleteRows(at: [oldIndexPath], with: .automatic)
                 tableView.insertRows(at: [newIndexPath], with: .automatic)
             case .delete:
                 guard let indexPath = indexPath else { return }
                 tableView.deleteRows(at: [indexPath], with: .automatic)
             @unknown default:
                 break
             
         }
     }
}

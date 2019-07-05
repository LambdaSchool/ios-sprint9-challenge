//
//  CalorieIntakeTableViewController.swift
//  CalorieTracker
//
//  Created by Thomas Cacciatore on 7/5/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieIntakeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//    var intakes: [Intake] {
//        //load from persistent store
//    }
    
   
//    let series = ChartSeries()
    
    @IBAction func addIntakeButtonTapped(_ sender: Any) {
        //alert popup with a text field.
        //User enters calories
        //create new calorie intake
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field.", preferredStyle: .alert)
        alert.addTextField()
        let submit = UIAlertAction(title: "Submit", style: .default) { [unowned alert] _ in
            guard let answer = alert.textFields?[0] else { return }
            //do something with "answer" here
            //create an intake and save it to core data.
            let calories = Int32(answer.text ?? "0")
            let intake = Intake(calories: calories ?? 0, timeStamp: Date())
            do {
                let moc = CoreDataStack.shared.mainContext
                try moc.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
            
        }
        alert.addAction(submit)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true)
        }))
        
        present(alert, animated: true)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieIntakeCell", for: indexPath)

        let intake = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = String(intake.calories)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: intake.timeStamp ?? Date())
        cell.detailTextLabel?.text = dateString

        return cell
    }


    // MARK: = NSFetchedResultsControllerDelegate Methods
    
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
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }

    
    // MARK: - Properties
    
    lazy var fetchedResultsController: NSFetchedResultsController<Intake> = {
        let fetchRequest: NSFetchRequest<Intake> = Intake.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: true), NSSortDescriptor(key: "calories", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "timeStamp", cacheName: nil)
        frc.delegate = self
        
        try! frc.performFetch()
        
        return frc
        
    }()
}

//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Michael Flowers on 7/5/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit
import CoreData

class CalorieTrackerViewController: UIViewController {

    let calorieController = CalorieController()
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "amount", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    
    func popUpToAddCalories(){
        let alert = UIAlertController(title: "Add Calorie Intake.", message: "Enter the amount of calories in the text field", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        var myTextField: UITextField!
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Add Calories"
            myTextField = textField
        })
        
        let okAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            //TODO: ADD WHAT'S IN THE TEXT TO THE TABLEVIEW
            guard let amountString = myTextField.text, !amountString.isEmpty else { print("Error unwrapping alert textfield.") ; return }
            self.calorieController.addCalorie(with: amountString)
            self.tableView.reloadData()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @IBAction func addCalories(_ sender: UIBarButtonItem) {
        popUpToAddCalories()
    }
}


extension CalorieTrackerViewController: NSFetchedResultsControllerDelegate {
    //MARK: - NSFRC DELEGATE METHODS
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //what do we want to do to the table view based on the change type?
        switch type {
            
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            //insert a cell when we add a model object
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            //we need both indexpaths, from indexpath to newIndexpath
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}


extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        
        let calorie = fetchedResultsController.object(at: indexPath)
        guard let stringAmount = calorie.amount else { return UITableViewCell() }
        let calorieString = "Calories: \(stringAmount)"
        cell.textLabel?.text = calorieString
        print("CaloriesDate: \(calorie.date)")
        
        guard let calDate = calorie.date else { print("Error unwrapping date in cellForAtRow"); return UITableViewCell() }
        print("we in here.")
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        let x = formatter.string(from: calDate)
        print("\(x)")
        cell.detailTextLabel?.text = formatter.string(from: calDate)
        
        return cell
    }
    
    
}

//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Craig Swanson on 2/23/20.
//  Copyright © 2020 Craig Swanson. All rights reserved.
//

import UIKit
import CoreData

class CalorieTrackerViewController: UIViewController {
    
    // MARK: - Properties
    var calorieTrackerController = CalorieTrackerController()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<CalorieTracker> = {
        let fetchRequest: NSFetchRequest<CalorieTracker> = CalorieTracker.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true)
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error in fetched results controller \(error)")
            fatalError("Error in fetched results controller \(error)")
        }
        return frc
    }()

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Control Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .addedCalorieEntry, object: nil)
        updateViews()
    }

    // MARK: - New Entry UI Alert
    @IBAction func addNewCalorieEntry(_ sender: UIBarButtonItem) {
        // show alert
        let alert = UIAlertController(title: "New Calorie Entry", message: "Add a new entry for calories consumed.", preferredStyle: .alert)
        // check for valid user entry
//        alert.addTextField { (textField) in
//            textField.placeholder = "Enter Calories"
//        }
        let submit = UIAlertAction(title: "Submit", style: .default) { _ in
            let textField = alert.textFields![0] as UITextField
            guard textField.text != "" else { return }
            guard let calories = textField.text,
            let validEntry = Double(calories) else { return }
            let newCalorieTracker = CalorieTracker(calories: validEntry)
            self.calorieTrackerController.addEntry(entry: newCalorieTracker)
        }
        
        alert.addTextField { textField in
            textField.placeholder = "EnterCalories"
        }
        alert.addAction(submit)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { _ in }
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        // call add action with text field contents
    }
    
    @objc func updateViews() {
        tableView.reloadData()
    }
}

// MARK: - Table View Data Source
extension CalorieTrackerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        
        let entry = fetchedResultsController.object(at: indexPath)
        
        let calories = String(entry.calories)
        cell.textLabel?.text = calories
        
        let entryTime = entry.timestamp
        cell.detailTextLabel?.text = Date.stringFormattedDate(from: entryTime!)
        
        return cell
    }
    
    
}

// MARK: - FRC Delegate
extension CalorieTrackerViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
}

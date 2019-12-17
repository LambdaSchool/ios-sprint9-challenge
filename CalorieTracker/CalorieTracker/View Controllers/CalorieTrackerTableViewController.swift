//
//  CalorieTrackerTableViewController.swift
//  CalorieTracker
//
//  Created by Bobby Keffury on 12/13/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var entryController = EntryController()
    
    var chartSeries: [ChartSeries] = []
    
    lazy var fetchedResultsController: NSFetchedResultsController<Entry> = {
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: true),
        ]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: "timestamp", cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc

    }()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var calorieChart: Chart!
    
    
    // MARK: - Views

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)

        let entry = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = "Calories: \(entry.calories)"
       
        cell.detailTextLabel?.text = entry.timestamp
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = fetchedResultsController.object(at: indexPath)
            
            let moc = CoreDataStack.shared.mainContext
            moc.delete(entry)
            do {
                try moc.save()
                tableView.reloadData()
            } catch {
                moc.reset()
                print("Error saving managed object context: \(error)")
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let addEntryAlert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: UIAlertController.Style.alert)
        
        addEntryAlert.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }

        addEntryAlert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action: UIAlertAction!) in
            guard let calories = addEntryAlert.textFields![0].text,
            let doubleCalories = Double(calories) else { return }
            
            self.entryController.createEntry(with: doubleCalories)
            addEntryAlert.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }))

        addEntryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            addEntryAlert.dismiss(animated: true, completion: nil)
        }))

        present(addEntryAlert, animated: true, completion: nil)
        setUpChart(calorieChart)
        
    }
    
    // MARK: - Methods

    func setUpChart(_ chart: Chart) {
        let calories = entryController.entries.map {  $0.calories }
        let series = ChartSeries(calories)
        chart.add(series)
    }
}

// MARK: - Extensions

extension CalorieTrackerTableViewController: NSFetchedResultsControllerDelegate {
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
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

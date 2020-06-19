//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Cody Morley on 6/19/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import UIKit
import SwiftChart
import CoreData

class ViewController: UIViewController {
    //MARK: - Properties -
    @IBOutlet weak var chartView: Chart!
    @IBOutlet weak var entriesTableView: UITableView!
    
    private lazy var frc = NSFetchedResultsController<Entry> = {
       let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
       fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp",
                                                         ascending: false)]
        let mainContext = CoreDataStack.shared.mainContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: mainContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error Fetching Results: \(error)")
        }
        return fetchedResultsController
    }()
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        entriesTableView.dataSource = self
        updateViews()
    }
    
    
    //MARK: - Actions -
    @IBAction func addButton(_ sender: Any) {
        createEntry()
        updateViews()
    }
    
    
    //MARK: - Methods -
    private func updateViews() {
        //clear
        
        //repopulate
    }
    
    private func createEntry() {
        let addEntry = UIAlertController(title: "Add Calorie Intake",
                                         message: "Enter number of calories:",
                                         preferredStyle: .alert)
        var calories: UITextField!
        addEntry.addTextField { textfield in
            calories = textfield
            calories.placeholder = "Calories:"
        }
        
        addEntry.addAction(UIAlertAction(title: "Add Entry",
                                         style: .default,
                                         handler: { _ in
                                            guard let caloriesString = calories.text,
                                                !caloriesString.isEmpty,
                                                let calories = Double(caloriesString) else { return }
                                            Entry(calories: calories)
                                            do {
                                                try CoreDataStack.shared.mainContext.save()
                                            } catch {
                                                NSLog("Unable to save entry to Core Data. Here's what went wrong: \(error) \(error.localizedDescription)")
                                                return
                                            }
                                            self.updateViews()
        }))
        present(addEntry, animated: true, completion: nil)
    }
}



//MARK: - Extension: Table View Data Source -
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        frc.fetchedObjects.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
        cell.textLabel?.text = String(frc.fetchedObjects[indexPath.row].calories)
        cell.detailTextLabel?.text = dateFormatter.string(from: frc.fetchedObjects[indexPath.row].timestamp)
        return cell
    }
}



//MARK: - Extension: FRC Delegate Methods -
extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        entriesTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        entriesTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            entriesTableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            entriesTableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
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
            entriesTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            entriesTableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            entriesTableView.deleteRows(at: [oldIndexPath], with: .automatic)
            entriesTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            entriesTableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}


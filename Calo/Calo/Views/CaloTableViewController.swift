//
//  CaloTableViewController.swift
//  Calo
//
//  Created by Gladymir Philippe on 10/11/20.
//  Copyright © 2020 Gladymir Philippe. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CaloTableViewController: UITableViewController {
    
    // Mark: IBOutlet
    @IBOutlet private weak var chartView: Chart!
    
    // Mark: - Properties
    let caloriesController = caloriesController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date",
        ascending: false)]
        
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching")
        }
        return frc
    }()

    // Mark: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {

    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CaloriesCell", for: indexPath)

        return cell
    }
    
}

// Mark: Extensions

extension CaloTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.begingUpdates()
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

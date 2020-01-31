//
//  CalorieEntryTableViewDataSource.swift
//  iOSSprintCalorieTracker
//
//  Created by Patrick Millet on 1/31/20.
//  Copyright © 2020 Patrick Millet. All rights reserved.
//

import UIKit
import CoreData

class CalorieEntryTableViewDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    weak var entryController: CalorieEntryController!
    weak var entryTableView: UITableView!
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entryController?.entryCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "EntryCell",
            for: indexPath)
        guard let entry = entryController?.getEntry(at: indexPath)
            else { return cell }
        
        cell.textLabel?.text = "\(entry.calories) calories"
        cell.detailTextLabel?.text = CalorieEntry.dateFormatter.string(
            from: entry.timestamp ?? Date())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let entryController = entryController,
            editingStyle == .delete {
            do {
                try entryController.deleteEntry(at: indexPath)
                NotificationCenter.default.post(name: .dataDidUpdate, object: self)
            } catch {
                NSLog("Error deleting entry: \(error)")
            }
        }
    }
}

// MARK: - FRC Delegate
extension CalorieEntryTableViewDataSource: PersistentStoreControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        entryTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        entryTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard
                let newIndexPath = newIndexPath
                else { return }
            entryTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard
                let indexPath = indexPath
                else { return }
            entryTableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard
                let oldIndexPath = indexPath,
                let newIndexPath = newIndexPath
                else { return }
            entryTableView.deleteRows(at: [oldIndexPath], with: .automatic)
            entryTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            entryTableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            NSLog("Unknown Core Data returned")
        }
    }
}

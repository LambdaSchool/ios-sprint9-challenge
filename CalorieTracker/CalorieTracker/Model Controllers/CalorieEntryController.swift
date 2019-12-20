//
//  CalorieEntryController.swift
//  CalorieTracker
//
//  Created by Jon Bash on 2019-12-20.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import CoreData

class CalorieEntryController {
    weak var delegate: NSFetchedResultsControllerDelegate?

    lazy var fetchedResultsController: NSFetchedResultsController<CalorieEntry> = {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: false)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil)
        frc.delegate = self.delegate
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error initializing fetched results controller: \(error)")
        }

        return frc
    }()

    var entryCount: Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }

    func entry(at indexPath: IndexPath) -> CalorieEntry {
        return fetchedResultsController.object(at: indexPath)
    }

    func saveToPersistentStore() throws {
        try CoreDataStack.shared.save()
    }

    func deleteEntry(at indexPath: IndexPath) {
        let thisEntry = entry(at: indexPath)
        CoreDataStack.shared.mainContext.delete(thisEntry)
        do {
            try saveToPersistentStore()
        } catch {
            NSLog("Error saving changes after deleting entry: \(error)")
        }
    }
}

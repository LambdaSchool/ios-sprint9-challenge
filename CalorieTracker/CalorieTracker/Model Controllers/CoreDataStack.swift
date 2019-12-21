//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Jon Bash on 2019-12-20.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Protocols

protocol PersistentStoreControllerDelegate: NSFetchedResultsControllerDelegate {}

extension NSManagedObjectContext: PersistentContext {}

class CoreDataStack: NSObject, PersistentStoreController {
    // MARK: - Properties

    weak var delegate: PersistentStoreControllerDelegate?

    lazy var container = setUpContainer()
    lazy var fetchedResultsController = setUpResultsController()

    private var masterContext: NSManagedObjectContext { container.viewContext }

    var allItems: [Persistable]? { fetchedResultsController.fetchedObjects }
    var itemCount: Int { fetchedResultsController.sections?[0].numberOfObjects ?? 0 }
    var mainContext: PersistentContext { masterContext }

    // MARK: - Setup

    func setUpContainer() -> NSPersistentContainer {
        // MUST MATCH XCDATAMODELD FILENAME
        let container = NSPersistentContainer(name: "CalorieTracker")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }

    func setUpResultsController() -> NSFetchedResultsController<CalorieEntry> {
        guard let moc = mainContext as? NSManagedObjectContext else {
            fatalError("Faulty main context in core data stack")
        }
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "timestamp", ascending: false)]
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
    }

    // MARK: - PersistentStoreController Methods

    func create(item: Persistable, in context: PersistentContext?) throws {
        let thisContext = getContext(context)
        try thisContext.save()
    }

    func getItem(at indexPath: IndexPath) -> Persistable? {
        return fetchedResultsController.object(at: indexPath)
    }

    func delete(
        itemAtIndexPath indexPath: IndexPath,
        in context: PersistentContext?
    ) throws {
        let thisContext = getContext(context)
        let entry = fetchedResultsController.object(at: indexPath)
        try delete(entry, in: thisContext)
    }

    func delete(_ item: Persistable?, in context: PersistentContext?) throws {
        let thisContext = getContext(context)

        guard let entry = item as? CalorieEntry else { throw NSError() }
        thisContext.delete(entry)
        try save(in: thisContext)
    }
    
    func save(in context: PersistentContext?) throws {
        let thisContext = getContext(context)
        var saveError: Error?
        // wait for it to finish so we can catch the error and throw it up to caller
        thisContext.performAndWait {
            do {
                try thisContext.save()
            } catch {
                saveError = error
            }
        }
        if let error = saveError { throw error }
    }

    func getContext(_ context: PersistentContext?) -> NSManagedObjectContext {
        if let context = context as? NSManagedObjectContext {
            return context
        } else {
            return masterContext
        }
    }
}

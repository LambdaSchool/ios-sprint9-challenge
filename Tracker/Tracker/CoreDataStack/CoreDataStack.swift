//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Nick Nguyen on 3/27/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    var mainContext: NSManagedObjectContext {
        return containter.viewContext
    }
    
    lazy var containter: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persitent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        return container
    }()
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        if let error = error { throw error }
    }
    
    
    func deleteCoreDataStore() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Calorie")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            let newContext = containter.newBackgroundContext
            try newContext().execute(deleteRequest)
            try newContext().save()
        } catch let err as NSError {
            NSLog("Error deleting data: \(err)")
        }
    }
}

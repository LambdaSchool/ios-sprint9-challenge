//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Kevin Stewart on 6/12/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CaloriesDataModel")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        // Allows backround thread context to upload changes to the main thread context automatically to show on the UI (Cordinater is the parent to both contexts)
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext  {
        return container.viewContext
    }
    
    // This lets us save any context on the right thread, avoiding concurrency issues
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        if let error = error {
            throw error
        }
    }
}

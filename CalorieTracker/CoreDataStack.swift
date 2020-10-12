//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Kenneth Jones on 10/12/20.
//

import Foundation
import CoreData

class CoreDataStack {
    // Static makes it a class property, not an instance property
    // (access it through CoreDataStack.shared, and it will be the same instance throughout the entire app)
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calories")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
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
}

//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Claudia Contreras on 6/12/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//
import Foundation
import CoreData

class CoreDataStack {
    
    // This is a shared instance of the Core Data Stack
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "Calories")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // Makes the access to the context faster
    // Reminds you to use the context on the main queue
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
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

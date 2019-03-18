//
//  CoreDataStack.swift
//  S9 Calorie Tracker
//
//  Created by Angel Buenrostro on 3/17/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack() // singleton, because there should only ever be ONE core data stack so singleton makes sense
    
    lazy var container: NSPersistentContainer = {
        
        // Give the container the name of your data model file, just using kCFBundleNameKey so we can save this code as a reusable snippet for other projects
        let container = NSPersistentContainer(name: "S9_Calorie_Tracker" as String)
        
        // Load the persistent store
        container.loadPersistentStores{ (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // This should help you remember that the viewContext should be used on the main thread
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}

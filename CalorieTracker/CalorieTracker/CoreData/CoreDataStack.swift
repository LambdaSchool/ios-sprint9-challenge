//
//  CoreDataStack.swift
//  CalorieTrackerTests
//
//  Created by Kobe McKee on 6/28/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CalorieLog")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load from persistent store: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
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
}

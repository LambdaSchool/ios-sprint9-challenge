//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by John McCants on 2/19/21.
//  Copyright © 2021 John McCants. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CalorieTracker")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error with container: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        context.performAndWait {
            do {
                try context.save()
            } catch let error {
                print("Save Error: \(error)")
            }
            
        }
        
    }
}

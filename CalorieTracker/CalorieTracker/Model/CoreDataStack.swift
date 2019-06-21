//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Christopher Aronson on 6/21/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CalorieTracker")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext  {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext) throws {
        
        var error: Error?
        
        context.performAndWait {
            
            do {
                try context.save()
            } catch let saveError{
                NSLog("Error saving moc: \(saveError)")
                error = saveError
            }
        }
        
        if let error = error {
            throw error
        }
    }
}

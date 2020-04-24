//
//  CoreDataStack.swift
//  Calorie Tracker
//
//  Created by Karen Rodriguez on 4/24/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    private init() {}
    
    static let shared = CoreDataStack()
    
    
    var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calories")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                NSLog("Couldn't load items from persistent store : \(error)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var saveError: Error?
        
        context.performAndWait {
            
            do {
                try context.save()
            } catch {
                saveError = error
            }
        }
        if let error = saveError { throw error }
    }
    
}

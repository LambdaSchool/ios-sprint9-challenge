//
//  CoreDataStack.swift
//  Calorie Tracker
//
//  Created by Jordan Christensen on 10/19/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "JournalCoreData" as String)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}

//
//  CoreDataStack.swift
//  CalorieTrackerApp
//
//  Created by Jerry haaser on 12/20/19.
//  Copyright © 2019 Jerry haaser. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    private init() { }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Core data was unable to load persistence stores: \(error)")
            }
        })
        return container
    }()
    
    var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save() {
        let context = CoreDataStack.shared.mainContext
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("error saving context: \(error)")
                context.reset()
            }
        }
    }
}

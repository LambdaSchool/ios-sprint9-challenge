//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Jonalynn Masters on 12/20/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    func saveContext(context: NSManagedObjectContext) throws {
        context.performAndWait {
            do {
                try context.save()
            }catch {
                NSLog("Error saving context: \(error)")
            }
        }
    }
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "User")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Error loading persistent stores: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}


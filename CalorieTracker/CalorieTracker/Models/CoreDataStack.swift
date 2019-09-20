//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Luqmaan Khan on 9/20/19.
//  Copyright © 2019 Luqmaan Khan. All rights reserved.
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

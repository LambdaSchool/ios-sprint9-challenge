//
//  CoreDataStack.swift
//  Calorie Tracker
//
//  Created by Bronson Mullens on 8/14/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // MARK: - Properties
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calories")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Error load persistent store: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    // MARK: - Methods
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error saving to CoreData")
            }
        }
    }
    
}

//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Clayton Watkins on 8/14/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    // MARK: - Properties
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistence stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    // MARK: - Method
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("Error saving to CoreData \(error)")
            }
        }
    }

}

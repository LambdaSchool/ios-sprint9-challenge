//
//  CoreDataStack.swift
//  Calorie Tracker
//
//  Created by Ivan Caldwell on 2/15/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    // MARK: - Properties
    static let shared = CoreDataStack()
    let mainContext: NSManagedObjectContext
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Calorie_Tracker")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("\nCoreDataStack.swift\nError: Could not load the data store. \n\(error)")
            } else {
                print (description)
            }
        }
        mainContext = container.viewContext
        mainContext.automaticallyMergesChangesFromParent = true
    }
    
    func save(context: NSManagedObjectContext) throws {
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


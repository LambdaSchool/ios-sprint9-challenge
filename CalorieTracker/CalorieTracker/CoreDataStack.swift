//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Gerardo Hernandez on 5/4/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}
    
    lazy var container: NSPersistentContainer = {
        let newContainer = NSPersistentContainer(name: "CalorieTracker")
        newContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        newContainer.viewContext.automaticallyMergesChangesFromParent = true
        return newContainer
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
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
        if let saveError = saveError { throw saveError }
    }
    
}


//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Chad Rutherford on 1/31/20.
//  Copyright © 2020 chadarutherford.com. All rights reserved.
//

import CoreData
import Foundation

enum CoreDataError: Error {
    case saveError
}

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        var container = NSPersistentContainer(name: "CalorieTracker")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var coreDataError: CoreDataError?
        
        context.perform {
            do {
                try context.save()
            } catch {
                coreDataError = .saveError
            }
        }
        
        if let error = coreDataError { throw error }
    }
}

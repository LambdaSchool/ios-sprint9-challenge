//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Paul Yi on 3/15/19.
//  Copyright © 2019 Paul Yi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CalorieTracker")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError( "There was an error trying to load persistent stores: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        context.performAndWait {
            do {
                try context.save()
            }
            catch let saveError {
                error = saveError
            }
        }
        if let error = error { throw error }
    }
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}

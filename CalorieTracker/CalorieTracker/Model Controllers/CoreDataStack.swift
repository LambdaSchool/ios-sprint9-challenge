//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Jon Bash on 2019-12-20.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = { // won't run until we ask for it
        let container = NSPersistentContainer(name: "CalorieTracker") // MUST MATCH XCDATAMODELD FILENAME
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        // wait for it to finish so we can catch the error and throw it up to caller
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        if let error = error { throw error }
    }
}

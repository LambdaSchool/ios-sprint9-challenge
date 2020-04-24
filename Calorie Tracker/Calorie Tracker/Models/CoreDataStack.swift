//
//  CoreDataStack.swift
//  Calorie Tracker
//
//  Created by Mark Gerrior on 4/24/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    /// Singleton. Only do once. Sharing state. Not _that_ expensive.
    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calorie_Tracker")
        container.loadPersistentStores { _, error  in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }

        /// This is required for the viewContext (ie. the main context) to be updated with changes saved in a background context. In this case, the viewContext's parent is the persistent store coordinator, not another context. This will ensure that the viewContext gets the changes you made on a background context so the fetched results controller can see those changes and update the table view automatically.
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
}

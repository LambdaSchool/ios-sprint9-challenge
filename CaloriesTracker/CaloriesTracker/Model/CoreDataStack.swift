//
//  CoreDataStack.swift
//  CaloriesTracker
//
//  Created by Bhawnish Kumar on 5/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CaloriesTracker")
        container.loadPersistentStores { _, error  in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }

        //This will make sure to make changes in the background for the view context.
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
}

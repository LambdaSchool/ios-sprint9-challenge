//
//  CoreDataStack.swift
//  CalorieTrackerSprint
//
//  Created by Jorge Alvarez on 2/28/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack() // access from anywhere in the app
    // static means not connected to any certain instance

    // lazy means create until it's accessed (expensive to make)
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CalorieTracker")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // Handle to the data in database
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
}

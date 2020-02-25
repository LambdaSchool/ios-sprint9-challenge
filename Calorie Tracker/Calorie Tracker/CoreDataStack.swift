//
//  CoreDataStack.swift
//  Calorie Tracker
//
//  Created by Alex Thompson on 2/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calorie")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading Core data stores: \(error)")
            }
        }
        return container
    }()

    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
}

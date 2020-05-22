//
//  CoreDataManager.swift
//  CalorieTracker
//
//  Created by Shawn James on 5/22/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    // create singleton
    static let shared = CoreDataManager()
    
    // create container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Entry")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // create context -> everything done in the app uses the context
    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
}

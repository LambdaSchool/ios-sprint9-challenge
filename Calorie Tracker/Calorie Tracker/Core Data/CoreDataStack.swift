//
//  CoreData.swift
//  Calorie Tracker
//
//  Created by Christy Hicks on 5/3/20.
//  Copyright © 2020 Knight Night. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack() 
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CalorieTracker")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
}

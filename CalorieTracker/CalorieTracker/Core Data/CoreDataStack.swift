//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Chris Dobek on 5/22/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CalorieIntake")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
}

//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Sean Hendrix on 1/11/19.
//  Copyright © 2019 Sean Hendrix. All rights reserved.
//

import Foundation
import CoreData

/// Utility class for dealing with the CoreData stack
class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext  {
        return container.viewContext
    }
}

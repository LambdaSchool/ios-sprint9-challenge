//
//  CoreDataStack.swift
//  Calorie Tracker
//
//  Created by Vici Shaweddy on 1/3/20.
//  Copyright © 2020 Vici Shaweddy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calorie")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error loading Core Data stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}

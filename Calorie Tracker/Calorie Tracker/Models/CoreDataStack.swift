//
//  CoreDataStack.swift
//  Calorie Tracker
//
//  Created by Niranjan Kumar on 12/20/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import Foundation
import CoreData

import CoreData

class CoreDataStack {
    // singleton
    static let shared = CoreDataStack()
    
    // "Lazy" will not run any of the this code unless we actually call this property
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calorie_Tracker")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load PersistentStores: \(error)")
            }
        }
        return container
    }()
    
    // review this subject
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}

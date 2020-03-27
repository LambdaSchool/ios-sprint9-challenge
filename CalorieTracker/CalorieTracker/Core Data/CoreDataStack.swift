//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by scott harris on 3/27/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let sahred = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "CalorieTracker")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed To Load Core Data Persistent Stores")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}

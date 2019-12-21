//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by brian vilchez on 12/20/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
   lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calorie")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                NSLog("failed to load from persistence store: \(error.localizedDescription).")
            }
        }
        return container
    }()
    var context: NSManagedObjectContext {
        return container.viewContext
    }
}

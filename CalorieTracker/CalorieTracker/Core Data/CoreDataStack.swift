//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Austin Cole on 2/15/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    let container: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "CalorieTracker")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("could not load the data store: \(error)")
            } else {
                print("\(description)")
            }
        }
        mainContext = container.viewContext
        mainContext.automaticallyMergesChangesFromParent = true
    }
}

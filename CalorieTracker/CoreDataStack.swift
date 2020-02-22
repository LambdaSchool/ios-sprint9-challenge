//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_201 on 2/22/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CalorieModel")
        container.loadPersistentStores { ( _, error) in
            if let error = error {
                fatalError("Error loading Core Data Stores: \(error)")
            }
        }
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
}

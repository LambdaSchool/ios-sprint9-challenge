//
//  CoreDataStack.swift
//  CalorieTracker-SwiftChart
//
//  Created by Yvette Zhukovsky on 1/11/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//

import CoreData
import Foundation



class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CalorieTracker" as String)
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true 
        return container
    }()
    
    var mainContext: NSManagedObjectContext { return container.viewContext }
}

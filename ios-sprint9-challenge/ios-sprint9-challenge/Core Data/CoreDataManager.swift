//
//  CoreDataManager.swift
//  ios-sprint9-challenge
//
//  Created by Conner on 9/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calories")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Could not load Calories from persistent store: \(error)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}

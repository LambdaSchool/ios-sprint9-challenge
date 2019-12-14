//
//  CoreDataStack.swift
//  Calorie Tracker
//
//  Created by Dillon P on 12/14/19.
//  Copyright © 2019 Lambda iOSPT2. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CalorieTracker")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Error loading Core Data Stack: \(error)")
            }
        }
        return container
        
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}

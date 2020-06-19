//
//  CoreDataStack.swift
//
//  Created by Thomas Sabino-Benowitz on 5/22/20.
//

import Foundation
import CoreData

class CoreDataStack {
    
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CalorieData")
        
        container.loadPersistentStores {_, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
}

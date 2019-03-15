//
//  CoreDataStack.swift
//  CalorieTraker
//
//  Created by Jocelyn Stuart on 3/15/19.
//  Copyright © 2019 JS. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private init() { }
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        
        let appName = Bundle.main.object(forInfoDictionaryKey: (kCFBundleNameKey as String)) as! String
        // Create a PersistentContainer
        let container = NSPersistentContainer(name: appName)
        
        // Load its PersistenStores
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // Also create a helper variable
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        return container.newBackgroundContext()
    }
}




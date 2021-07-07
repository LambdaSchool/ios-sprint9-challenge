//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_214 on 10/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    private let coreDataModelName = "CalorieData"
    static let shared = CoreDataStack()
    
    private init() {
    }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: coreDataModelName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Unable to load persistent store! Error: \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error saving context: \(error)")
                context.reset()
            }
        }
    }
}

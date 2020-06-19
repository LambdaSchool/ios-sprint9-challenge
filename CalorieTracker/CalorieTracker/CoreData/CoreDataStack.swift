//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Joe Veverka on 6/19/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CalorieEntry")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed loading persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var saveError: Error?
        context.performAndWait {
            do {
                try context.save()
            } catch {
                context.reset()
                saveError = error
            }
        }
        if let error = saveError {throw error}
    }
}

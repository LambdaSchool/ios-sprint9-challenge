//
//  CoreDataStack.swift
//  Calorie Counter
//
//  Created by Sal B Amer on 5/1/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calorie")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistant store: \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
        } catch let saveError {
            error = saveError
        }
    }
        if let error = error { throw error }
}
}

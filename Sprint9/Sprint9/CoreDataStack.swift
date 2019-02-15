//
//  CoreDataStack.swift
//  Sprint9
//
//  Created by Sergey Osipyan on 2/15/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calorie")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Couldn't load the data store: \(error)")
            }
        }
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
            }
            catch let saveError {
                error = saveError
            }
        }
        if let error = error { throw error }
    }
}

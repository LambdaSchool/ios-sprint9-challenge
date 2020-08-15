//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Lambda_School_loaner_226 on 8/14/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let coreData = CoreDataStack()
    
    func save(context: NSManagedObjectContext = CoreDataStack.coreData.mainContext) throws {
        var saveError: Error?
        context.performAndWait {
            do {
                try context.save()
            } catch {
                saveError = error
            }
        }
        if let error = saveError { throw error }
    }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CalorieTracker")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
}

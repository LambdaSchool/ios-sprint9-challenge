//
//  CoreDataStack.swift
//  iosCalorieTrackrSprintChallenge
//
//  Created by BrysonSaclausa on 10/10/20.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Calories")
        container.loadPersistentStores { (_, error) in
        if let error = error {
            fatalError("\(error)")
        }
    }
     container.viewContext.automaticallyMergesChangesFromParent = true
    return container
}()
    
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
    
    var mainContext: NSManagedObjectContext {
    return container.viewContext
    
   }
}

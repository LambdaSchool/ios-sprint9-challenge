//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Chad Parker on 6/12/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
   static let shared = CoreDataStack()
   
   lazy var container: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "CalorieTracker")
      container.loadPersistentStores { _, error in
         if let error = error {
            fatalError("Failed to load persistent stores: \(error)")
         }
      }
      container.viewContext.automaticallyMergesChangesFromParent = true
      return container
   }()
   
   var mainContext: NSManagedObjectContext {
      container.viewContext
   }
   
   // This lets us save any context on the right thread, avoiding concurrency issues.
   func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
      var error: Error?
      
      context.performAndWait {
         do {
            try context.save()
         } catch let saveError as NSError {
            error = saveError
         }
      }
      
      if let error = error {
         throw error
      }
   }
}

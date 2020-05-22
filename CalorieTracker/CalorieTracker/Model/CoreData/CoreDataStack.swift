//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Mark Poggi on 5/22/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {

          let container = NSPersistentContainer(name: "CalorieTracker")

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

    func save(context: NSManagedObjectContext) throws {
        var error: Error?

        do {
            try context.save()
        } catch let saveError {
            error = saveError
        }

        if let error = error { throw error }
    }
}

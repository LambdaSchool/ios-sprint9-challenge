//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Keri Levesque on 3/27/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {

    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Calorie")

        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()

    var mainContext: NSManagedObjectContext {
        return container.viewContext
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


//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Mark Gerrior on 4/24/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {

    // MARK: - Properities
    var entries: [Entity] {
        loadFromPersistentStore()
    }

    // MARK: - CRUD

    // Create
    func create(calories: Int,
                timestamp: Date = Date()) {

        Entity(calories: calories,
               timestamp: timestamp,
               context: CoreDataStack.shared.mainContext)

        saveToPersistentStore()
    }

    private func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed error context: \(error)")
        }
    }

    // Read
    private func loadFromPersistentStore() -> [Entity] {
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()

        do {
            return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
        }
        return []
    }

    // Update
    // Delete
}

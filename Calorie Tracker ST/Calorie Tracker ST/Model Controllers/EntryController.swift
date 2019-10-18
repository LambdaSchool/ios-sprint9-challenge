//
//  EntryController.swift
//  Calorie Tracker ST
//
//  Created by Jake Connerly on 10/18/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

class EntryController {

    // MARK: - Properties

    static var entries: [Entry] = []

    // MARK: - Create

    func createEntry(calorieCount: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            let convertedInt = Int32(calorieCount)
            let newEntry = Entry(calories: convertedInt, dateEntered: Date())
            EntryController.entries.append(newEntry)
            do {
                try CoreDataStack.shared.save(context: context)
                NotificationCenter.default.post(name: .entriesUpdated, object: self)
            } catch {
                NSLog("Error saving context when creating new Entry:\(error)")
            }
        }
    }

    // MARK: - Update

    func updateEntry(entry: Entry, calorieCount: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            let convertedInt = Int32(calorieCount)
            entry.calories = convertedInt
            entry.dateEntered = Date()

            do {
                try CoreDataStack.shared.save(context: context)
                NotificationCenter.default.post(name: .entriesUpdated, object: self)
            } catch {
                NSLog("Error saving context when updating Entry:\(error)")
            }
        }
    }

    // MARK: - Delete

    func deleteEntry(entry: Entry, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            context.delete(entry)
            do {
                try CoreDataStack.shared.save(context: context)
                NotificationCenter.default.post(name: .entriesUpdated, object: self)
            } catch {
                NSLog("Error saving context when deleting Entry:\(error)")
            }
        }
    }
}

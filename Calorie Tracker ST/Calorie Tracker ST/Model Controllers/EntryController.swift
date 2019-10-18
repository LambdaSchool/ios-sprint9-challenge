//
//  EntryController.swift
//  Calorie Tracker ST
//
//  Created by Jake Connerly on 10/18/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

class entryController {
    
    var entries: [Entry] = []
    
    func createEntry(calorieCount: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            let convertedInt = Int32(calorieCount)
            let newEntry = Entry(calories: convertedInt, dateEntered: Date())
            entries.append(newEntry)
            do {
                try CoreDataStack.shared.save(context: context)
                NotificationCenter.default.post(name: .entriesUpdated, object: self)
            } catch {
                NSLog("Error saving context when creating new Entry:\(error)")
            }
        }
    }
    
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

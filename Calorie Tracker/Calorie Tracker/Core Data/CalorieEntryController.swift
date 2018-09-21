//
//  CalorieEntryController.swift
//  Calorie Tracker
//
//  Created by Samantha Gatt on 9/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import CoreData

class CalorieEntryController {
    
    var calorieEntries: [CalorieEntry] {
        return loadFromPersistentStore()
    }
    
    func addCalorieEntry(_ calories: Double) -> Double {
        let xCoord = Double(self.calorieEntries.count + 1)
        _ = CalorieEntry(calories: calories, xCoord: xCoord)
        saveToPersistentStore()
        return xCoord
    }
    
    func saveToPersistentStore(context: NSManagedObjectContext = CoreDataStack.moc) {
        context.performAndWait {
            do {
                try context.save()
            }
            catch {
                NSLog("Error saving entry: \(error)")
            }
        }
    }
    
    func loadFromPersistentStore(context: NSManagedObjectContext = CoreDataStack.moc) -> [CalorieEntry] {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
            return []
        }
    }
}

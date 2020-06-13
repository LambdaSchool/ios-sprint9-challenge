//
//  CalorieEntryController.swift
//  CalorieTrackerApp
//
//  Created by Jarren Campos on 6/12/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import Foundation
import CoreData

extension NSNotification.Name {
    static let addCalorieEntry = NSNotification.Name("AddCalorieEntry")
}

class CalorieEntryController {
    
    var calorieEntries: [CalorieEntry] = []
    static let shared = CalorieEntryController()
    
    func loadFromPersistentStore() {
        let context = CoreDataStack.shared.mainContext
        
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        
        context.performAndWait {
            do {
                let previousEntries = try context.fetch(fetchRequest)
                calorieEntries = previousEntries
            } catch {
                NSLog("Error fetching calorie entries: \(error)")
            }
        }
    }
    
    // MARK: - CRUD
    func createCalorieEntry(calories: Int) {
        let calories: Int16 = Int16(calories)
        let calorieEntry = CalorieEntry(calories: calories)
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving context")
            return
        }
        calorieEntries.append(calorieEntry)
    }
    
    func deleteCalorieEntry(calorieEntry: CalorieEntry) {
        let context = CoreDataStack.shared.mainContext
        context.delete(calorieEntry)
        try? context.save()
        guard let index = calorieEntries.firstIndex(of: calorieEntry) else { return }
        calorieEntries.remove(at: index)
    }

}

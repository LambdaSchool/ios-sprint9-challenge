//
//  CalorieEntryController.swift
//  CalorieTracker
//
//  Created by Christopher Devito on 4/24/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation
import CoreData

class CalorieEntryController {
    
    var calorieEntries: [CalorieEntry] = []
     
    func saveToPersistentStore() {
        // TODO: -
    }
    
    func loadFromPersistentStore() {
        // TODO: -
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
        guard let index = calorieEntries.firstIndex(of: calorieEntry) else { return }
        calorieEntries.remove(at: index)
    }
    
    
}

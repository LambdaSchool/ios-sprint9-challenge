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
        }
        calorieEntries.append(calorieEntry)
    }
    
    func deleteCalorieEntry() {
        // TODO: -
    }
    
    
}

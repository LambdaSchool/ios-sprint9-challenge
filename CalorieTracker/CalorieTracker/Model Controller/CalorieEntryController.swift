//
//  CalorieEntryController.swift
//  CalorieTracker
//
//  Created by Mitchell Budge on 6/28/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import Foundation
import CoreData

class CalorieEntryController {
    
    func saveCalorieEntryToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func addCalorieEntry(numberOfCalories: Double) {
        _ = CalorieEntry(numberOfCalories: numberOfCalories)
        saveCalorieEntryToPersistentStore()
    }
    
//    func deleteCalorieEntry(calorieEntry: CalorieEntry) {
//        let moc = CoreDataStack.shared.mainContext
//        moc.delete(calorieEntry)
//        saveCalorieEntryToPersistentStore()
//    }
}

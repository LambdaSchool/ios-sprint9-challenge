//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Clayton Watkins on 8/14/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import Foundation

class CaloriesController {
    private (set) var calories: [CalorieEntry] = []
    
    // Function to save any created calorie entry
    func createCalorieEntry(with amount: String) {
        let calories = CalorieEntry(calorieAmount: amount)
        self.calories.append(calories)
        do {
            try saveToPersistantStore()
        } catch {
            print("Error saving calorie entry")
        }
    }
    
    func deleteCalorieEntry(withCalorie calories: CalorieEntry) {
           let moc = CoreDataStack.shared.mainContext
           moc.delete(calories)
           
           do {
               try self.saveToPersistantStore()
           } catch {
               NSLog("Error saving after delete method")
           }
       }
       
    
    func saveToPersistantStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}

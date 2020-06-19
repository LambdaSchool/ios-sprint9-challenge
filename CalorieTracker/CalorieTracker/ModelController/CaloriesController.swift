//
//  CaloriesController.swift
//  CalorieTracker
//
//  Created by Enzo Jimenez-Soto on 6/19/20.
//  Copyright © 2020 Enzo Jimenez-Soto. All rights reserved.
//

import Foundation

class CaloriesController {
    private (set) var calories: [Calories] = []
    
    func createCalories(withCalorieCount calorieCount: String) {
        let calories = Calories(calories: calorieCount)
        self.calories.append(calories)
        
        do {
            try self.saveToPersistantStore()
        } catch {
            NSLog("Error trying to save to Core Data")
        }
    }
    
    func deleteCalories(withCalorie calories: Calories) {
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

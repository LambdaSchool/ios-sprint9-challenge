//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Michael Stoffer on 9/14/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

class CalorieController {
    private (set) var calories: [Calorie] = []
    
    func createCalorie(withCalorieCount calorieCount: String) {
        let calorie = Calorie(calories: calorieCount)
        self.calories.append(calorie)
        
        do {
            try self.saveToPersistantStore()
        } catch {
            NSLog("Error trying to save to Core Data")
        }
    }
    
    func saveToPersistantStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}

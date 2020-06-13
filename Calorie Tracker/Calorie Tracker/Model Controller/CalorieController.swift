//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by patelpra on 6/13/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import Foundation

class CalorieController {
    private (set) var calories: [Calorie] = []
    
    func createdCalorie(withCalorieCount calorieCount: String) {
        let calorie = Calorie(calories: calorieCount)
        self.calories.append(calorie)
        
        do {
            try self.saveToPersistentStore()
        } catch {
            NSLog("Error trying to save to Core Data")
        }
    }
    
    func deleteCalorie(withCalorie calorie: Calorie) {
        let moc = CoreDataStack.shared.mainContext
        moc.delete(calorie)
        
        do {
            try self.saveToPersistentStore()
        } catch {
            NSLog("Error saving")
        }
    }
    
    func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}

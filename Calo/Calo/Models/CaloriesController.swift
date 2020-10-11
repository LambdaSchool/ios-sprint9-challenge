//
//  CaloriesController.swift
//  Calo
//
//  Created by Gladymir Philippe on 10/11/20.
//  Copyright © 2020 Gladymir Philippe. All rights reserved.
//

import Foundation

class CaloriesController {
    // MARK: - Properties
    private (set) var calories: [CalorieEntry] = []

    // MARK: - Methods
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

    // Function to delete any created calorie entry
    func deleteCalorieEntry(withCalorie calories: CalorieEntry) {
           let moc = CoreDataStack.shared.mainContext
           moc.delete(calories)

           do {
               try self.saveToPersistantStore()
           } catch {
               NSLog("Error saving after delete method")
           }
       }

    // MARK: - Helper Method
    // func to save to Coredata
    func saveToPersistantStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}

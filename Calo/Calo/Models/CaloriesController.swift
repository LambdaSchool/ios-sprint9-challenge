//
//  CaloriesController.swift
//  Calo
//
//  Created by Gladymir Philippe on 10/11/20.
//  Copyright © 2020 Gladymir Philippe. All rights reserved.
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
    
    func savetoPersistantStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}

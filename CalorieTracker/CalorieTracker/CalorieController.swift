//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_268 on 3/27/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation


class CaloriesController {
    
    private (set) var calories: [Calorie] = []
    
    func createCalorie(withCalorieAmount amount: String) {
        let calorie = Calorie(amount: amount)
        self.calories.append(calorie)
        
        do {
            try self.save()
        } catch {
            NSLog("Error saving")
        }
    }
    func save() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}

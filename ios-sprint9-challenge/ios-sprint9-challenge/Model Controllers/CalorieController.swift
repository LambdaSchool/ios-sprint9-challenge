//
//  CalorieController.swift
//  ios-sprint9-challenge
//
//  Created by Conner on 9/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation

class CalorieController {
    func addCalories(amount: Int) {
        let calorie = Calorie(amount: Int32(amount))
        caloriesTracked.append(calorie)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            let moc = CoreDataManager.shared.mainContext
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    var caloriesTracked: [Calorie] = []
}

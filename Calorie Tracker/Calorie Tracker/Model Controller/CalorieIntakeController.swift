//
//  CalorieIntakeController.swift
//  Calorie Tracker
//
//  Created by Moses Robinson on 3/8/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import Foundation

class CalorieIntakeController {
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.save()
        } catch {
            CoreDataStack.shared.mainContext.reset()
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func create(calories: Double) {
        
        _ = CalorieIntake(calories: calories)
        saveToPersistentStore()
    }
    
    func delete(calorieIntake: CalorieIntake) {
        
        let moc = CoreDataStack.shared.mainContext
        moc.delete(calorieIntake)
        saveToPersistentStore()
    }
}

//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Madison Waters on 10/26/18.
//  Copyright © 2018 Jonah Bergevin. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
//    func calorieValue(with value: UInt16, timestamp: Date) {
//
//        let calories = Calories(value: UInt16, timestamp: Date)
//        saveToPersistentStore()
//    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
}

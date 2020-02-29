//
//  CalorieIntakeController.swift
//  CalorieTracker
//
//  Created by Michael on 2/28/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import Foundation
import SwiftChart

class CalorieIntakeController {
    
    var calorieIntakes: [Double] = []
    
    func delete(for calorieIntake: CalorieIntake) {
        CoreDataStack.shared.mainContext.delete(calorieIntake)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
            CoreDataStack.shared.mainContext.reset()
        }
    }
    
    func addCaloriteData(calories: Double) -> [Double] {
        var caloriesArray: [Double] = []
        caloriesArray.append(calories)
        return caloriesArray
    }
}

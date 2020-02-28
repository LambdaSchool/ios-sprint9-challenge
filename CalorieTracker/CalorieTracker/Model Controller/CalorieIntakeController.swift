//
//  CalorieIntakeController.swift
//  CalorieTracker
//
//  Created by Michael on 2/28/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import Foundation

class CalorieIntakeController {
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
}

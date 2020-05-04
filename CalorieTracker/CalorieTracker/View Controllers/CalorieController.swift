//
//  calorieController.swift
//  CalorieTracker
//
//  Created by Joshua Rutkowski on 5/3/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import Foundation

class CalorieController {
    
    func deleteCalorie(_ calorieIntake: CalorieIntake) {
        let context = CoreDataStack.shared.mainContext
        
        do {
            context.delete(calorieIntake)
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            context.reset()
            print("Error deleting object from managed object context: \(error)")
        }
    }
}

//
//  CaloriesController.swift
//  Calorie Tracker
//
//  Created by macbook on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class IntakeController {
    
    // CRUD
    
    // Create
    
    func createIntake(with calories: Int16, context: NSManagedObjectContext) {
        Intake(calories: calories, context: context)
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    // Update
    
    func updateIntake(intake: Intake, calories: Int16, date: Date = Date()) {
        intake.calories = calories
        intake.date = date
        CoreDataStack.shared.saveToPersistentStore()
    }
    
    // Delete
}


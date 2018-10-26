//
//  DailyIntakeController.swift
//  CalorieTracker
//
//  Created by Daniela Parra on 10/26/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

class DailyIntakeController {
    
    // MARK: - CRUD Methods
    
    func add(calories: Int) {
        let dailyIntake = DailyIntake(calories: calories)
        dailyIntakes.append(dailyIntake)
        
        saveToPersistentStore()
    }
    
    // MARK: - Persistent Store
    
    private func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    // MARK: - Properties
    
    private(set) var dailyIntakes: [DailyIntake] = []
}

//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Luqmaan Khan on 9/20/19.
//  Copyright © 2019 Luqmaan Khan. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    
    func saveToPersistentStore() {
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving to persistent store: \(error)")
            moc.reset()
        }
    }
    
    func addCaloriesToUser(calories: String, timeStamp: Date) {
        
        var dietLevel: String?
        guard let intCalories = Int(calories) else {return}
        if intCalories >= 3000 {
            dietLevel = "Danger Zone"
        } else if intCalories < 3000 && intCalories >= 1500 {
            dietLevel = "Sweet Spot"
        } else {
            dietLevel = "Calorie Intake Too Low"
        }
        guard let dietProgress = dietLevel else {return}
        _ = User(calories: calories, timestamp: timeStamp, dietLevel: dietProgress)
        saveToPersistentStore()
    }
    
}

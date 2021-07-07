//
//  CalorieDataController.swift
//  CalorieTracker
//
//  Created by Sameera Roussi on 6/28/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//



import UIKit
import CoreData

class CalorieDataController {
    
    func addCalorieDataPoint(newCalories: Int16) {
        let newCalorieAmount = Calories(caloriesRecorded: Int(newCalories))
        calorieData.append(newCalorieAmount)
        
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Unable to save the calorie data point \(error)")
        }
    }
    
    // MARK: - Properties
    private var calorieData: [Calories] = []
}




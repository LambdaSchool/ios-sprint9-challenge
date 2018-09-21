//
//  CalorieEntryController.swift
//  Calorie Tracker
//
//  Created by Samantha Gatt on 9/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

class CalorieEntryController {
    
    var calorieEntries: [CalorieEntry] = []
    
    func addCalorieEntry(_ calories: Double) -> Double {
        let xCoord = Double(self.calorieEntries.count + 1)
        let calorieEntry = CalorieEntry(calories: calories, xCoord: xCoord)
        calorieEntries.append(calorieEntry)
        return xCoord
    }
}

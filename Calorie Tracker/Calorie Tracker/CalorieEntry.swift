//
//  CalorieEntry.swift
//  Calorie Tracker
//
//  Created by Samantha Gatt on 9/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation

struct CalorieEntry {
    
    init(calories: Double, xCoord: Double, date: Date = Date()) {
        self.calories = calories
        self.xCoord = xCoord
        self.date = date
    }
    
    var calories: Double
    var xCoord: Double
    var date: Date
}

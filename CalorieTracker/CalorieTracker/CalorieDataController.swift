//
//  CalorieDataController.swift
//  CalorieTracker
//
//  Created by Dillon McElhinney on 10/26/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

class CalorieDataController {
    // MARK: - Properties
    private(set) var calorieDatas: [CalorieData] = [] {
        didSet {
            // Notify the observers that the data has been updated.
            NotificationCenter.default.post(name: .updatedCalorieDataNotification, object: nil)
        }
    }
    
    let healthKit = HealthKitHelper.shared
    
    // MARK: - Properties
    init() {
        healthKit.requestAuthorization { (success) in
            if success {
                self.fetchHealthKitCalories()
            } else {
                NSLog("There was some problem fetching calorie data.")
            }
        }
    }
    
    // MARK: - CRUD Methods
    func createCalorieData(calories: Double, timestamp: Date = Date()) {
        let newCalorie = CalorieData(calories: calories, timestamp: timestamp)
        
        calorieDatas.append(newCalorie)
        healthKit.saveCalorieData(newCalorie)
    }
    
    func fetchHealthKitCalories() {
        healthKit.fetchCalorieData { (calories) in
            self.calorieDatas = calories
        }
    }
}

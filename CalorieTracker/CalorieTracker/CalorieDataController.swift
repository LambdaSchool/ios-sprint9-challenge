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
    private(set) var calorieDatas: [NewCalorieData] = [] {
        didSet {
            // Notify the observers that the data has been updated.
            NotificationCenter.default.post(name: .updatedCalorieDataNotification, object: nil)
        }
    }
    
    let healthKit = HealthKitHelper.shared
    
    // MARK: - Properties
    init() {
        fetchHealthKitCalories()
    }
    
    // MARK: - CRUD Methods
    func createCalorieData(calories: Double, timestamp: Date = Date()) {
        let newCalorie = NewCalorieData(calories: calories, timestamp: timestamp)
        
        calorieDatas.append(newCalorie)
        healthKit.saveCalorieData(newCalorie)
    }
    
    func fetchHealthKitCalories() {
        healthKit.fetchCalorieData { (calories) in
            self.calorieDatas = calories
        }
    }
}

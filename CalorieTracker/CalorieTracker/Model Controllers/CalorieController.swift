//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Madison Waters on 2/16/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let caloriesDidChange = Notification.Name("caloriesDidChange")
}

class CalorieController {
    
    var calories: [Calorie] = []
    
    var chartCalories: [String] = []
    
    var calorieValueChanged: Bool {
        get { return self.calorieValueChanged }
        set { NotificationCenter.default.post(name: .caloriesDidChange, object: self) }
    }
    
    let moc = CoreDataStack.shared.mainContext
    
    func calorieCount() -> Int {
        return calories.count
    }
    
    func addCalorie(calorie: String) {
        let newCalories = Calorie(value: calorie, timestamp: Date.init(), context: moc)
        calories.append(newCalories)
        
        do { try moc.save() }
        catch { NSLog("Error saving to managed object context") }
    }
    
}

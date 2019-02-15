//
//  CalorieController.swift
//  Calorie Tracker
//
//  Created by Madison Waters on 2/15/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let caloriesDidChange = Notification.Name("caloriesDidChange")
}

class CalorieController {
    
    private (set) var calories: [Calorie] = []
    
    func calorieCount() -> Int {
        return calories.count
    }
    
    func getCalorie(calorie: Calorie) -> Calorie {
        return calorie
    }
    
    func findCalorie(at index: Int) -> Calorie {
        return calories[index]
    }
    
    func addCalorie(calorie: Calorie) -> [Calorie] {
        calories.append(calorie)
        return calories
    }
    
}

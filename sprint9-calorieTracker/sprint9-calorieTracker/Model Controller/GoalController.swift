//
//  GoalController.swift
//  sprint9-calorieTracker
//
//  Created by Nikita Thomas on 1/11/19.
//  Copyright © 2019 Nikita Thomas. All rights reserved.
//

import Foundation


class GoalController {
    static let shared = GoalController()
    
    func saveGoal(calories: Int) {
        
        UserDefaults.standard.set(calories, forKey: "goal")
        
    }
    
    func retrieveGoal() -> Int {
        let goal = UserDefaults.standard.integer(forKey: "goal")
        
        if goal != 0 {
            return goal
        } else {
            return 2000
        }
    }
    
}

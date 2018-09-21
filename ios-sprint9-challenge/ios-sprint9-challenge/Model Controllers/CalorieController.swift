//
//  CalorieController.swift
//  ios-sprint9-challenge
//
//  Created by Conner on 9/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation

class CalorieController {
    func addCalories(amount: Int) {
        let calorie = Calorie(amount: amount)
        caloriesTracked.append(calorie)
    }
    
    var caloriesTracked: [Calorie] = []
}

//
//  Calorie.swift
//  ios-sprint9-challenge
//
//  Created by Conner on 9/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation

struct CalorieRepresentation {
    
    init(amount: Int, date: Date = Date()) {
        self.amount = amount
        self.date = date
    }
    
    let amount: Int
    let date: Date
}

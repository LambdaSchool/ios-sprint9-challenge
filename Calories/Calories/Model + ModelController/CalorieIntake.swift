//
//  CalorieIntake.swift
//  Calories
//
//  Created by Jason Modisett on 1/11/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import Foundation

struct CalorieIntake: Codable {
    
    let name: String
    let amount: CGFloat
    let timestamp: Date
    
    init(name: String, amount: CGFloat) {
        self.name = name
        self.amount = amount
        self.timestamp = Date()
    }
    
}

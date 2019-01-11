//
//  CalorieIntakeRepresentation.swift
//  Calories
//
//  Created by Jason Modisett on 1/11/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import Foundation

// MARK:- CalorieIntakeRepresentation model

struct CalorieIntakeRepresentation: Codable, Equatable {
    
    let name: String
    let amount: Float
    let timestamp: Date
    let identifier: String
    
    init(name: String, amount: CGFloat, identifier: String = UUID().uuidString) {
        self.name = name
        self.amount = Float(amount)
        self.timestamp = Date()
        self.identifier = identifier
    }
    
}

// MARK:- Equatable functions

func ==(lhs: CalorieIntakeRepresentation, rhs: CalorieIntake) -> Bool {
    return rhs.identifier == lhs.identifier
}

func ==(lhs: CalorieIntake, rhs: CalorieIntakeRepresentation) -> Bool {
    return rhs.identifier == lhs.identifier
}

func !=(lhs: CalorieIntakeRepresentation, rhs: CalorieIntake) -> Bool {
    return rhs != lhs
}

func !=(lhs: CalorieIntake, rhs: CalorieIntakeRepresentation) -> Bool {
    return rhs != lhs
}

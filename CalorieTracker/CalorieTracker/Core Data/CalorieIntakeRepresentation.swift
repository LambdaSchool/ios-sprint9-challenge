//
//  CalorieIntakeRepresentation.swift
//  CalorieTracker
//
//  Created by Julian A. Fordyce on 3/15/19.
//  Copyright © 2019 Julian A. Fordyce. All rights reserved.
//

import Foundation


struct CalorieIntakeRepresentation: Decodable, Equatable {
    
    let calories: Double
    let timestamp: Date
    let identifier: String
    
}

func == (lhs: CalorieIntakeRepresentation, rhs: CalorieIntake) -> Bool {
    return lhs.calories == rhs.calories && lhs.timestamp == rhs.timestamp && lhs.identifier == rhs.identifier
}

func == (lhs: CalorieIntake, rhs: CalorieIntakeRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: CalorieIntakeRepresentation, rhs: CalorieIntake) -> Bool {
    return !(rhs == lhs)
}

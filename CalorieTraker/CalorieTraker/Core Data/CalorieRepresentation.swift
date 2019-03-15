//
//  CalorieRepresentation.swift
//  CalorieTraker
//
//  Created by Jocelyn Stuart on 3/15/19.
//  Copyright © 2019 JS. All rights reserved.
//

import Foundation

struct CalorieRepresentation: Decodable, Equatable {
    
    let amount: Int64
    let timestamp: Date
    
}

func ==(lhs: CalorieRepresentation, rhs: Calorie) -> Bool {
    return rhs.amount == lhs.amount &&
        rhs.timestamp == lhs.timestamp
}

func ==(lhs: Calorie, rhs: CalorieRepresentation) -> Bool {
    return rhs == lhs
}

func !=(lhs: CalorieRepresentation, rhs: Calorie) -> Bool {
    return !(lhs == rhs)
}

func !=(lhs: Calorie, rhs: CalorieRepresentation) -> Bool {
    return rhs != lhs
}

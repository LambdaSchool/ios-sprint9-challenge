//
//  CaloriesRepresentation.swift
//  Calories
//
//  Created by Hayden Hastings on 6/28/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import Foundation

struct CaloriesRepresentation: Decodable, Equatable {
    
    let calories: Double
    let date: Date
    
}

func == (lhs: CaloriesRepresentation, rhs: Calories) -> Bool {
    return lhs.calories == rhs.calories && lhs.date == rhs.date
}

func == (lhs: Calories, rhs: CaloriesRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: CaloriesRepresentation, rhs: Calories) -> Bool {
    return !(rhs == lhs)
}

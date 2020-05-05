//
//  CalorieRepresentation.swift
//  Calorie Counter
//
//  Created by Sal B Amer on 5/2/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import Foundation

struct CalorieRepresentation: Codable {
    var calories: Int
    var date: TimeInterval
    var identifier: String?
}



//
//  CalorieRepresentation.swift
//  Calorie Tracker
//
//  Created by Lotanna Igwe-Odunze on 2/15/19.
//  Copyright © 2019 Sugabelly LLC. All rights reserved.
//

import Foundation

struct CalorieRep: Equatable, Codable {
    var amount: Double
    var date: Date
    let id: UUID
}

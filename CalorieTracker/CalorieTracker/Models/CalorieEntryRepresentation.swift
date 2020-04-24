//
//  CalorieEntryRepresentation.swift
//  CalorieTracker
//
//  Created by Shawn Gee on 4/24/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation

struct CalorieEntryRepresentation: Codable {
    let calories: Int
    let date: TimeInterval // seconds since reference date
    let id: String
}

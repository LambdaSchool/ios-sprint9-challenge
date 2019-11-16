//
//  CalorieTrackerRepresentation.swift
//  Calorie Tracker
//
//  Created by Jesse Ruiz on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct CalorieTrackerRepresentation: Codable {
    let date: Date
    let calorie: String
    let identifier: UUID
}

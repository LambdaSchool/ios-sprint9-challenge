//
//  EntryRepresentation.swift
//  CALORIE-TRACKER
//
//  Created by Kelson Hartle on 6/19/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {

    var identifier: String
    var timeStamp: Date
    var numOfCalories: String

}

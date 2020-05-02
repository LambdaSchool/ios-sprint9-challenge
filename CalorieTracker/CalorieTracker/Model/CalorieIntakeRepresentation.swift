//
//  CalorieIntakeRepresentation.swift
//  CalorieTracker
//
//  Created by Jessie Ann Griffin on 5/1/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import Foundation

struct CalorieIntakeRepresentation: Codable {
    let calories: Int16
    let date: Date
    let time: Date
}

struct CalorieIntakeRepresentations: Codable {
    let results: [CalorieIntakeRepresentation]
}

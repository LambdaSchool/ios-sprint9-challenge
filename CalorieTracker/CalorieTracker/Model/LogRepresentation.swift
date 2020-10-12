//
//  LogRepresentation.swift
//  CalorieTracker
//
//  Created by Zachary Thacker on 10/12/20.
//

import Foundation

struct LogRepresentation: Codable {
    var id: String
    var calories: Int
    var date: Date
}

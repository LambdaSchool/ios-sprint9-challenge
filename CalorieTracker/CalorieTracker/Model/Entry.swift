//
//  Entry.swift
//  CalorieTracker
//
//  Created by Cody Morley on 6/19/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import SwiftChart

struct Entry {
       var calories: Double
       var timestamp: Date
       var formatter: DateFormatter {
           let formatter = DateFormatter()
           formatter.dateStyle = .short
           return formatter
       }
       lazy var formattedDate = formatter.date(from: String(timestamp.description))
       
       init(calories: Double, timestamp: Date = Date()) {
           self.calories = calories
           self.timestamp = timestamp
       }
}

//
//  TimestampFormatter.swift
//  Calorie Tracker
//
//  Created by Madison Waters on 10/27/18.
//  Copyright © 2018 Jonah Bergevin. All rights reserved.
//

import Foundation

class TimestampFormatter {
    
    static func formatTimestamp(for calories: Calories) -> String {
        return dateFormatter.string(from: calories.timestamp!)
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
}

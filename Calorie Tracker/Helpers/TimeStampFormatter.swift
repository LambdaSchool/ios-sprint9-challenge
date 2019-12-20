//
//  TimeStamp.swift
//  Calorie Tracker
//
//  Created by macbook on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class TimestampFormatter {
    
    static func formatTimestamp(for intake: Intake) -> String {
        return dateFormatter.string(from: intake.date!)
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
}

//Will return 00/00/00, 00:00pm

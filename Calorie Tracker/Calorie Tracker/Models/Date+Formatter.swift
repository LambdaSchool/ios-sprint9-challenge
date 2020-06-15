//
//  Date+Formatter.swift
//  Calorie Tracker
//
//  Created by Matthew Martindale on 6/14/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String = "MMM dd, yy HH:mm:ss a ") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

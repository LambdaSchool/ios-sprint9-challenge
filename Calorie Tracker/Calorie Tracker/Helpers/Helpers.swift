//
//  Helpers.swift
//  Calorie Tracker
//
//  Created by Chris Gonzales on 3/27/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation

extension Date {
static func getFormattedDate(date: Date, format: String = "MMM d, h:mm a") -> String {
    let dateformat = DateFormatter()
    dateformat.dateFormat = format
    return dateformat.string(from: date)
}
}

extension NSNotification.Name {
    static let addedEntry = NSNotification.Name("AddedEntry")
}


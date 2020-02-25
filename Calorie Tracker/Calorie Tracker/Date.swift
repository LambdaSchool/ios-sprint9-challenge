//
//  Date.swift
//  Calorie Tracker
//
//  Created by Alex Thompson on 2/25/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

extension Date {
    static func dateToString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}



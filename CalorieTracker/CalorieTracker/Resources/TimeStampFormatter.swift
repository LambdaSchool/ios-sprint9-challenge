//
//  TimeStampFormatter.swift
//  CalorieTracker
//
//  Created by Zachary Thacker on 10/12/20.
//

import Foundation

class TimeStampFormatter {
    
static func formatdate (for log: CalorieLog) -> String {
    return dateFormatter.string(from: log.date!)
    }

static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yy"
    return dateFormatter
}()
}

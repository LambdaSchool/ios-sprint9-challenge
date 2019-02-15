//
//  CalorieData.swift
//  CalorieTracker
//
//  Created by Dillon McElhinney on 2/15/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

struct CalorieData {
    let calories: Double
    let timestamp: Date
    
    var formattedTimestamp: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: timestamp)
    }
    
    var chartTime: Double {
        let components = CalorieData.calendar.dateComponents([.hour, .minute], from: timestamp)
        return Double("\(components.hour ?? 0).\(components.minute ?? 0 / 60)") ?? 0
    }
    
    static let calendar: Calendar = {
        let calendar = Calendar.current
        return calendar
    }()
}

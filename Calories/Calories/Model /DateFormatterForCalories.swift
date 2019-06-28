//
//  DateFormatterForCalories.swift
//  Calories
//
//  Created by Hayden Hastings on 6/28/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import Foundation

struct DateFormatterForCalories {
    static var dateFormatter: DateFormatter {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
}

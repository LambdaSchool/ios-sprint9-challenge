//
//  DateHelper.swift
//  CalorieTracker
//
//  Created by Julian A. Fordyce on 3/15/19.
//  Copyright © 2019 Julian A. Fordyce. All rights reserved.
//

import Foundation

struct DateFormat {
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    let timestamp: Date = Date()

}

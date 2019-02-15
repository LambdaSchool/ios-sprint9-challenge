//
//  NewCalorieData.swift
//  CalorieTracker
//
//  Created by Dillon McElhinney on 2/15/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

struct NewCalorieData {
    let calories: Double
    let timestamp: Date
    
    var formattedTimestamp: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: timestamp)
    }
}

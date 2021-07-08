//
//  Calorie.swift
//  CalorieTracker-SwiftChart
//
//  Created by Yvette Zhukovsky on 1/11/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//

import Foundation


struct CalorieModel {
    let timestamp: Date
    let number: Int
    
    init(timestamp: Date = Date(), number: Int) {
        self.timestamp = timestamp
        self.number = number

    }
    
}


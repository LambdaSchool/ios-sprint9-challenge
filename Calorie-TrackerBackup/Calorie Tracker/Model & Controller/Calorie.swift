//
//  Calorie.swift
//  Calorie Tracker
//
//  Created by Madison Waters on 2/15/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import Foundation

struct Calorie {
    
    let value: Int
    let timestamp: Date

    init(value: Int, timestamp: Date = Date()) {
        self.value = value
        self.timestamp = timestamp
    }
    
}

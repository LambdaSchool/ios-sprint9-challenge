//
//  CalorieEntry+Convenience.swift
//  CalorieTracker
//
//  Created by Christopher Devito on 4/24/20.
//  Copyright © 2020 Christopher Devito. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    
    @discardableResult convenience init(calories: Int16,
                                        identifier: UUID = UUID(),
                                        timestamp: Date = Date()) {
        self.init()
        self.identifier = identifier
        self.calories = calories
        self.timestamp = timestamp
    }
    
    
}

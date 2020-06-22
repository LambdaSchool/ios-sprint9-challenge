//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Austin Cole on 2/15/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {
    
    convenience init(calories: Double, timestamp: Date, identifier: String, user: String? = nil, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
        self.identifier = identifier
        self.user = user
    }
    
}

//
//  CalorieDataPoint+Convenience.swift
//  CalorieTracker
//
//  Created by David Wright on 5/4/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import Foundation
import CoreData

extension CalorieDataPoint {
    @discardableResult
    convenience init(calories: Double,
                     timestamp: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
    }
    
    @discardableResult
    convenience init(calories: Double,
                     userName: String,
                     timestamp: Date = Date(),
                     userId: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
        self.userName = userName
        self.userId = userId
    }
}

//
//  Calories + Convenience.swift
//  Calorie Tracker
//
//  Created by Bohdan Tkachenko on 8/15/20.
//  Copyright © 2020 Bohdan Tkachenko. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(calorieCount: Double, date: Date = Date(), id: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.date = date
        self.id = id
        self.calorieCount = calorieCount
    }
}

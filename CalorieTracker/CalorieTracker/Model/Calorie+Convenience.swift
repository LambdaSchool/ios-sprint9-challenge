//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Harmony Radley on 6/19/20.
//  Copyright © 2020 Harmony Radley. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    @discardableResult convenience init(calorieAmount: Double, date: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calorieAmount = calorieAmount
        self.date = date
    }
}

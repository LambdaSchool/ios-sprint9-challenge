//
//  CalorieIntake+Convenience.swift
//  CalorieTracker
//
//  Created by Joshua Rutkowski on 5/3/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {
    @discardableResult convenience init(calorieCount: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)

        self.calorieCount = Int16(calorieCount)
        self.date = Date()
    }
}

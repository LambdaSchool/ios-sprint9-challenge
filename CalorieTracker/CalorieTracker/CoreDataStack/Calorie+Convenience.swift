//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Keri Levesque on 3/27/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import Foundation
import CoreData


extension Calorie {
    @discardableResult convenience init(calorieAmount: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)

        self.calorieAmount = Int16(calorieAmount)
        self.date = Date()
    }
}

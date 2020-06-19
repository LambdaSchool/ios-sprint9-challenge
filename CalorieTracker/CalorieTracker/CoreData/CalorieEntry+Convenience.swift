//
//  CalorieEntry+Convenience.swift
//  CalorieTracker
//
//  Created by Joe Veverka on 6/19/20.
//  Copyright © 2020 Joe Veverka. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    @discardableResult convenience init(calories: Int, date: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Int16(calories)
        self.date = date
    }
}

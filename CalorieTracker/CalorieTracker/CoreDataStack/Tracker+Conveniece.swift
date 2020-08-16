//
//  Tracker+Conveniece.swift
//  CalorieTracker
//
//  Created by Josh Kocsis on 8/14/20.
//

import Foundation
import CoreData

extension Tracker {

    @discardableResult convenience init(calories: Int16,
                                        date: Date = Date(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.date = date
    }
}

//
//  Calories+Convenience.swift
//  CalorieTracker
//
//  Created by Kenneth Jones on 10/12/20.
//

import Foundation
import CoreData

extension Calories {
    @discardableResult convenience init(intake: Double, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.intake = intake
        self.timestamp = timestamp
    }
}

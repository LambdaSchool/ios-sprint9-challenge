//
//  Intake+Convenience.swift
//  CalorieTracker
//
//  Created by Cora Jacobson on 10/10/20.
//

import Foundation
import CoreData

extension Intake {
    @discardableResult convenience init(calories: Int,
                                        timestamp: Date = Date(),
                                        identifier: UUID = UUID(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.calories = Int16(calories)
        self.timestamp = timestamp
    }
}

//
//  Calorie+Convenience.swift
//  CalorieCounter
//
//  Created by Joel Groomer on 12/14/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(amount: Int,
                     timestamp: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.amount = Int16(amount)
        self.timestamp = timestamp
    }
}

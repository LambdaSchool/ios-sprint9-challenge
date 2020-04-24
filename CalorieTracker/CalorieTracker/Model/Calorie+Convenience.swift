//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Ezra Black on 4/24/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
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

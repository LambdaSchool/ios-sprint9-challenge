//
//  Calorie+Convenience.swift
//  Calories
//
//  Created by Norlan Tibanear on 10/10/20.
//  Copyright © 2020 Norlan Tibanear. All rights reserved.
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

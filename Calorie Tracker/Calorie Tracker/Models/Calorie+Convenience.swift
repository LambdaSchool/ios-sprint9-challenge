//
//  Calorie+Convenience.swift
//  Calorie Tracker
//
//  Created by Thomas Dye on 6/14/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
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

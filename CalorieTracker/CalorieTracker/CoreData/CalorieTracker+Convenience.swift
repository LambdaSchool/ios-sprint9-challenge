//
//  CalorieTracker+Convenience.swift
//  CalorieTracker
//
//  Created by Craig Belinfante on 10/11/20.
//  Copyright © 2020 Craig Belinfante. All rights reserved.
//

import Foundation
import CoreData

extension CalorieTracker {
    @discardableResult convenience init(identifier: UUID = UUID(), calories: Int, time: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.calories = Int16(calories)
        self.time = time
    }
}


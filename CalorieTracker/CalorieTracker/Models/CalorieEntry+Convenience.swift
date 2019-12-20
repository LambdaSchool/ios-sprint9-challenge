//
//  CalorieEntry+Convenience.swift
//  CalorieTracker
//
//  Created by Jon Bash on 2019-12-20.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    convenience init(
        calories: Double,
        timestamp: Date = Date(),
        identifier: UUID = UUID(),
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
        self.init(context: context)
        
        self.calories = calories
        self.timestamp = timestamp
        self.identifier = identifier
    }
}

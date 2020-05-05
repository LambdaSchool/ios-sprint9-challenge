//
//  CalorieTracker+Convenience.swift
//  CalorieTracker
//
//  Created by Gerardo Hernandez on 5/4/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import Foundation
import CoreData

extension CalorieData {
    @discardableResult
    convenience init(calories: Double,
                     timestamp: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
    }

}

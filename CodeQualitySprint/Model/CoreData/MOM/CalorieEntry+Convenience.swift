//
//  CalorieEntry+Convenience.swift
//  CodeQualitySprint
//
//  Created by Kenny on 2/28/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    ///initialize with default context
    @discardableResult convenience init(calories: Int, date: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Int16(calories)
        self.date = date
    }
}

//
//  CalorieEntry+Convenience.swift
//  CalorieSprint
//
//  Created by Enrique Gongora on 3/27/20.
//  Copyright © 2020 Enrique Gongora. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    @discardableResult convenience init(calories: Int, date: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Int16(calories)
        self.date = date
    }
}

//
//  CalorieIntake+Convenience.swift
//  Calorie Tracker
//
//  Created by Christy Hicks on 5/3/20.
//  Copyright © 2020 Knight Night. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {
    convenience init(calories: Int, dateEntered: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Int16(calories)
        self.dateEntered = dateEntered
    }
}

//
//  CalorieIntake+Convenience.swift
//  CalorieTrackerSprint
//
//  Created by Jorge Alvarez on 2/28/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
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

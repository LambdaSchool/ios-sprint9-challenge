//
//  CalorieIntake+Convenience.swift
//  CalorieTracker
//
//  Created by Chris Dobek on 5/22/20.
//  Copyright © 2020 Chris Dobek. All rights reserved.
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

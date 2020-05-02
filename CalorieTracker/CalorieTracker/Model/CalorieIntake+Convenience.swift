//
//  CalorieIntake+Convenience.swift
//  CalorieTracker
//
//  Created by Jessie Ann Griffin on 5/1/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {
    convenience init(calories: Int16,
                     date: Date = Date(),
                     time: Date,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.date = date
        self.time = time
    }
}

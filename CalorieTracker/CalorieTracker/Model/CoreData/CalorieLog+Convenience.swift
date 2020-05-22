//
//  CalorieLog+Convenience.swift
//  CalorieTracker
//
//  Created by Mark Poggi on 5/22/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import Foundation
import CoreData

extension CalorieLog {
    convenience init(numberOfCalories: Double, logDate: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.numberOfCalories = numberOfCalories
        self.logDate = logDate
    }
}

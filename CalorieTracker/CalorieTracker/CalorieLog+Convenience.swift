//
//  CalorieLog+Convenience.swift
//  CalorieTracker
//
//  Created by Kobe McKee on 6/28/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    
    convenience init(calories: Int32, logDate: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.logDate = logDate
    }
}

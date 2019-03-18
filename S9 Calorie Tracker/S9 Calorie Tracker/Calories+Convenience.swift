//
//  Calories+Convenience.swift
//  S9 Calorie Tracker
//
//  Created by Angel Buenrostro on 3/17/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import CoreData

extension Calories {
    
    convenience init(calorieAmount: String, timeStamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.calorieAmount = calorieAmount
        self.timeStamp = timeStamp
    }
}


//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_34 on 3/15/19.
//  Copyright © 2019 Frulwinn. All rights reserved.
//

import CoreData

extension CalorieIntake {
    convenience init(calories: Double, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
    }
}

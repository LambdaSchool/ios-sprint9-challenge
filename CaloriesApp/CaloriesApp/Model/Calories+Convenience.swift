//
//  Calories+Convenience.swift
//  CaloriesApp
//
//  Created by Nelson Gonzalez on 3/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
    
    convenience init(calorieAmount: Double, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.calorieAmount = calorieAmount
        self.date = date
    }
    
}

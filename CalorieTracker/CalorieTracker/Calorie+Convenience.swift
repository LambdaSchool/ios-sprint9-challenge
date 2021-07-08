//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Carolyn Lea on 9/21/18.
//  Copyright © 2018 Carolyn Lea. All rights reserved.
//

import Foundation
import CoreData

extension Calorie
{
    convenience init(calorieAmount: String, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        self.init(context: context)
        self.calorieAmount = calorieAmount
        self.timestamp = timestamp
    }
    
}

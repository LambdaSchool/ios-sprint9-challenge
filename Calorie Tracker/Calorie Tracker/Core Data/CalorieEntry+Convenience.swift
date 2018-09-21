//
//  CalorieEntry+Convenience.swift
//  Calorie Tracker
//
//  Created by Samantha Gatt on 9/21/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    
    convenience init(calories: Double, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.moc) {
        self.init(context: context)
        self.calories = calories
        self.date = date
    }
}

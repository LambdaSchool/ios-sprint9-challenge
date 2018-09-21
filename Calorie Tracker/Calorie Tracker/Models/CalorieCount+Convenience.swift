//
//  CalorieCount+Convenience.swift
//  Calorie Tracker
//
//  Created by Jonathan T. Miles on 9/21/18.
//  Copyright © 2018 Jonathan T. Miles. All rights reserved.
//

import Foundation
import CoreData

extension CalorieCount {
    convenience init(calories: Int64, date: Date = Date(), managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: managedObjectContext)
        self.calories = calories
        self.date = date
    }
}

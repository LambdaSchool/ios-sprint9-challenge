//
//  Calories.swift
//  Calorie Tracker
//
//  Created by Bronson Mullens on 8/14/20.
//  Copyright © 2020 Bronson Mullens. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
    
    convenience init(calories: Int,
                     dateAdded: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Int16(calories)
        self.dateAdded = dateAdded
        
    }
}

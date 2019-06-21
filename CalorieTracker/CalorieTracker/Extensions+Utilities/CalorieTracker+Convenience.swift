//
//  CalorieTracker+Convenience.swift
//  CalorieTracker
//
//  Created by Christopher Aronson on 6/21/19.
//  Copyright © 2019 Christopher Aronson. All rights reserved.
//

import Foundation
import CoreData

extension CalorieTracker {
    convenience init(calories: Int16, timestamp: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.calories = calories
        self.timestamp = timestamp
    }
}

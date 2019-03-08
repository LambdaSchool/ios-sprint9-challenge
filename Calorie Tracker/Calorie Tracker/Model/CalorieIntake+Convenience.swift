//
//  CalorieIntake+Convenience.swift
//  Calorie Tracker
//
//  Created by Moses Robinson on 3/8/19.
//  Copyright © 2019 Moses Robinson. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {
    
    convenience init (calories: Int16, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        (self.calories, self.timestamp) = (calories, timestamp)
    }
}

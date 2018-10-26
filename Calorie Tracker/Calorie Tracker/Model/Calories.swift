//
//  Calories.swift
//  Calorie Tracker
//
//  Created by Madison Waters on 10/26/18.
//  Copyright © 2018 Jonah Bergevin. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
    
    convenience init(timestamp: Date = Date(),
                     value: UInt16,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)
        
        self.timestamp = timestamp
        self.value = Int16(value)
        
    }
}

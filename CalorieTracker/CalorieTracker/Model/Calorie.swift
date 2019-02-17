//
//  Calorie.swift
//  CalorieTracker
//
//  Created by Madison Waters on 2/16/19.
//  Copyright © 2019 Jonah Bergevin. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    
    convenience init(value: String,
                     timestamp: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.value = value
        self.timestamp = timestamp
        
    }
}

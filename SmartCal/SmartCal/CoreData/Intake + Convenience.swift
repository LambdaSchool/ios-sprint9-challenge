//
//  Intake + Convenience.swift
//  SmartCal
//
//  Created by Farhan on 10/26/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import Foundation
import CoreData

extension Intake {
    
    convenience init(calories: Int32, timestamp: Date = Date(),  context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.calories = calories
        self.timestamp = timestamp
    }
    
    
}

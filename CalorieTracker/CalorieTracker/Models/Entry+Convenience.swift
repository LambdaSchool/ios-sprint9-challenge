//
//  Entry+Convenience.swift
//  CalorieTracker
//
//  Created by Bobby Keffury on 12/13/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(calories: String, timestamp: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
    }
    
}

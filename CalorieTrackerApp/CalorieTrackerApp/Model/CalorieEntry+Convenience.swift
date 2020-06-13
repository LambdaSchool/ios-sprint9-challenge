//
//  CalorieEntry+Convenience.swift
//  CalorieTrackerApp
//
//  Created by Jarren Campos on 6/12/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    
    @discardableResult convenience init(calories: Int16,
                                        identifier: UUID = UUID(),
                                        timestamp: Date = Date(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.calories = calories
        self.timestamp = timestamp
    }
    
    
}

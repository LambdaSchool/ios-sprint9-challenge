//
//  CalorieEntry+Convenience.swift
//  CalorieTracker
//
//  Created by scott harris on 3/27/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    
    convenience init(calories: Double, identifier: UUID = UUID(), date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.sahred.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.identifier = identifier
        self.date = date
    }
}

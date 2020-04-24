//
//  CalorieEntry+Convenience.swift
//  CalorieTracker
//
//  Created by Mitchell Budge on 6/28/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    
    convenience init(numberOfCalories: Double, entryDate: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.numberOfCalories = numberOfCalories
        self.entryDate = entryDate
    }
}

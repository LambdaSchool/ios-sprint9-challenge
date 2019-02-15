//
//  CalorieTrackerEntry+Convenience.swift
//  CalorieTrackerDaily
//
//  Created by jkaunert on 2/15/19.
//  Copyright © 2019 jkaunert. All rights reserved.
//

import Foundation
import CoreData

extension CalorieTrackerEntry {
    
    convenience init(calories: Int32, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.date = date
    }
}

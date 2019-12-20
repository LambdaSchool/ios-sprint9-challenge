//
//  Entry+Convenience.swift
//  CalorieTrackerApp
//
//  Created by Jerry haaser on 12/20/19.
//  Copyright © 2019 Jerry haaser. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(calories: Double, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.date = date
        self.calories = calories
    }
}


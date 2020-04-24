//
//  CalorieEntry+Convenience.swift
//  CalorieTracker
//
//  Created by Shawn Gee on 4/24/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import CoreData
import Foundation

extension CalorieEntry {
    convenience init(date: Date, calories: Int, id: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.date = date
        self.calories = Int64(calories)
        self.id = id
    }
}

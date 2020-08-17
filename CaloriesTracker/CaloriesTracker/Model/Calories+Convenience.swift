//
//  Calories+Convenience.swift
//  CaloriesTracker
//
//  Created by Ian French on 8/16/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {

    @discardableResult convenience init(calorieValue: Double, date: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calorieValue = calorieValue

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd-yyyy HH:mm:ss"
        let formatDate = dateFormatter.string(from: Date())
        self.date = formatDate
    }
}

//
//  CalorieTracker+Convenience.swift
//  CalorieTracker
//
//  Created by Nonye on 6/19/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import Foundation
import CoreData

extension CalorieData {
    @discardableResult
    convenience init(calories: Double, calorieDate: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.calorieDate = calorieDate
    }
    
    var date: String {
            guard let calorieDate = self.calorieDate else { return "" }

            let df = DateFormatter()
            df.dateFormat = "MMM d Y 'at' h:mm a"
            let date = df.string(from: calorieDate)
            return date
        }
}

//
//  Calories+Convenience.swift
//  Calories
//
//  Created by Hayden Hastings on 6/28/19.
//  Copyright © 2019 Hayden Hastings. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
    convenience init(calories: Double, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.date = date
    }
    
    var formattedDate: String? {
        guard let date = date else { return nil }
        return DateFormatterForCalories.dateFormatter.string(from: date)
    }
}

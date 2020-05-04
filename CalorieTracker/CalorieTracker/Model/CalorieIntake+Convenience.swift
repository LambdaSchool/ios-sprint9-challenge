//
//  CalorieIntake+Convenience.swift
//  CalorieTracker
//
//  Created by Jessie Ann Griffin on 5/1/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {

    convenience init(calories: Double,
                     date: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm:ss"

        dateFormatter.timeZone = NSTimeZone(name: "EST") as TimeZone?
        let convertedDate = dateFormatter.string(from: date)
        let time = timeFormatter.string(from: date)

        self.calories = calories
        self.date = convertedDate
        self.time = time
    }
}

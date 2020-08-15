//
//  Calories+Convenience.swift
//  CalorieTracker
//
//  Created by Morgan Smith on 8/14/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
    convenience init(calorieCount: Double, date: Date = Date(), id: UUID = UUID(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)

        self.date = date
        self.id = id
        self.calorieCount = calorieCount
    }
}

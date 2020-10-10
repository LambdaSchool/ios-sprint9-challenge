//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Rob Vance on 8/14/20.
//  Copyright © 2020 Robs Creations. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(amount: Int, timestamp: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
           self.init(context: context)
           self.amount = Int16(amount)
           self.timestamp = timestamp
       }
}
extension Notification.Name {
    static var calorieLogChanged = Notification.Name("calorieLogChanged")
}

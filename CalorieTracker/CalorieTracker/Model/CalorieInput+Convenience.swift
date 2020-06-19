//
//  CalorieInput+Convenience.swift
//  CalorieTracker
//
//  Created by Dahna on 6/19/20.
//  Copyright © 2020 Dahna Buenrostro. All rights reserved.
//

import Foundation
import CoreData

extension CalorieInput {
     
        @discardableResult convenience init(calories: Int,
                                               date: Date = Date(),
                                               context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            self.init(context: context)
            self.calories = Int16(calories)
            self.date = date
    }
}

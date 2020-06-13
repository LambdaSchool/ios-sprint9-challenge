//
//  Calories+Convenience.swift
//  CalorieTracker
//
//  Created by Claudia Contreras on 6/12/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
    @discardableResult convenience init(amount: Int16,
                                        date: Date = Date(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.amount = amount
        self.date = date
    }
}

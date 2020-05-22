//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Hunter Oppel on 5/22/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    @discardableResult convenience init(amount: String,
                                        date: Date = Date(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.amount = amount
        self.date = date
    }
}

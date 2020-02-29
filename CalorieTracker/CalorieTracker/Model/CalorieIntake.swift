//
//  CalorieIntake.swift
//  CalorieTracker
//
//  Created by Michael on 2/28/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {
    @discardableResult convenience init(calories: Int, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Int64(calories)
        self.date = date
    }
}

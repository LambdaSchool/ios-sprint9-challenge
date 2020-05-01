//
//  Entry+Convenience.swift
//  CalorieTracker
//
//  Created by Andrew Dhan on 9/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(date: Date = Date(), calories: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.date = date
        self.calories = Int32(calories)
    }
}

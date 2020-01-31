//
//  Entry+Convenience.swift
//  CalorieTracker
//
//  Created by Chad Rutherford on 1/31/20.
//  Copyright © 2020 chadarutherford.com. All rights reserved.
//

import CoreData
import Foundation

extension Entry {
    @discardableResult convenience init(calories: Int, date: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Int64(calories)
        self.date = date
    }
}

//
//  Entry+Convenience.swift
//  calorie tracker
//
//  Created by Thomas Sabino-Benowitz on 5/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(calories: Double, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.date = date
    }
}

//
//  Entry+Convenience.swift
//  Calorie Tracker ST
//
//  Created by Jake Connerly on 10/18/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(calories: Int32, dateEntered: Date?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)

        self.calories = calories
        self.dateEntered = dateEntered
    }
}

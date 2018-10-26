//
//  Entry+Convinience.swift
//  Calorie Tracker
//
//  Created by Iyin Raphael on 10/26/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
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

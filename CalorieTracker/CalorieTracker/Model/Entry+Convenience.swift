//
//  Entry+Convenience.swift
//  CalorieTracker
//
//  Created by Jerry haaser on 11/15/19.
//  Copyright © 2019 Jerry haaser. All rights reserved.
//

import Foundation
import CoreData

extension Entry {    
    convenience init(calories: Double, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.date = date
        self.calories = calories
    }
}

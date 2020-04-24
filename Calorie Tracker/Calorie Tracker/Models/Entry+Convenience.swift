//
//  Entry+Convenience.swift
//  Calorie Tracker
//
//  Created by Wyatt Harrell on 4/24/20.
//  Copyright © 2020 Wyatt Harrell. All rights reserved.
//

import Foundation
import CoreData

extension Entry {

    @discardableResult convenience init(numberOfCalories: Double, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.numberOfCalories = numberOfCalories
        self.timestamp = timestamp
    }
    
}

//
//  Entry+Convenience.swift
//  CalorieTracker
//
//  Created by Cody Morley on 6/19/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import CoreData


extension Entry {
    
    convenience init(calories: Double, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
    }
}

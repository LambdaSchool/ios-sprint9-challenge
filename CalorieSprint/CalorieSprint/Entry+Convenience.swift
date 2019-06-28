//
//  Entry+Convenience.swift
//  CalorieSprint
//
//  Created by Ryan Murphy on 6/28/19.
//  Copyright © 2019 Ryan Murphy. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    
    convenience init(calories: Int, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.numberOfCalories = Int16(calories)
        self.timestamp = timestamp
    }
}

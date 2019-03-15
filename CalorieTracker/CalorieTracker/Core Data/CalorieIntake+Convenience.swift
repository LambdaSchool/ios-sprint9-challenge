//
//  CalorieIntake+Convenience.swift
//  CalorieTracker
//
//  Created by Paul Yi on 3/15/19.
//  Copyright © 2019 Paul Yi. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {
    
    convenience init(identifier: String = UUID().uuidString, calorie: Int16, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.identifier = identifier
        self.calorie = calorie
        self.timestamp = timestamp
    }
}

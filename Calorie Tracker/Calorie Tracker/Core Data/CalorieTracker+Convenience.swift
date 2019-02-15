//
//  CalorieTracker+Convenience.swift
//  Calorie Tracker
//
//  Created by Ivan Caldwell on 2/15/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    convenience init(calorie: Double, identifier: UUID = UUID(), timestamp: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calorie = calorie
        self.timestamp = timestamp
        // Don't think I need this will decide later...
        self.identifier = identifier
        
    }
}

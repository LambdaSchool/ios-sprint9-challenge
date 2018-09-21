//
//  Calorie+Convenience.swift
//  Calorie Tracker
//
//  Created by Linh Bouniol on 9/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(name: String, calorie: Int64, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.name = name
        self.calorie = calorie
        self.timestamp = timestamp
    }
}

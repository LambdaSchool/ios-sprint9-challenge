//
//  Calorie+Convenience.swift
//  Calorie Tracker
//
//  Created by Alex Thompson on 2/22/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(calorie: Int16,
                     timestamp: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.calorie = calorie
        self.timestamp = timestamp
    }
}

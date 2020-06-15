//
//  Calorie+Convenience.swift
//  Calorie Tracker
//
//  Created by Matthew Martindale on 6/14/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    @discardableResult convenience init(
        count: Int64,
        date: Date = Date(),
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.count = count
        self.date = date
    }
}

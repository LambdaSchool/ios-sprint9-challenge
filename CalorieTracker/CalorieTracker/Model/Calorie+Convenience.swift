//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Bradley Yin on 9/20/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(count: Double, date: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.count = count
        self.date = date
    }
}

//
//  Calorie+convenience.swift
//  CalorieTracker
//
//  Created by brian vilchez on 12/20/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(intake: Double, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.init(context: context)
        self.intake = intake
        self.date = date
    }
}

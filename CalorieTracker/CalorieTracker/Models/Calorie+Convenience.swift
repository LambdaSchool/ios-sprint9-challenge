//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Gi Pyo Kim on 11/15/19.
//  Copyright © 2019 GIPGIP Studio. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    @discardableResult convenience init(calorie: Int16, date: Date, context: NSManagedObjectContext) {
        self.init(context: context)
        self.calorie = calorie
        self.date = date
    }
}

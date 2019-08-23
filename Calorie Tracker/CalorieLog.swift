//
//  CalorieLog.swift
//  Calorie Tracker
//
//  Created by Cameron Dunn on 3/15/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import Foundation
import CoreData

extension CalorieLogStore{
    @discardableResult convenience init(calories: Double, date: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context: context)
        self.calories = Double(exactly: calories) ?? 0
        self.date = date
    }
}

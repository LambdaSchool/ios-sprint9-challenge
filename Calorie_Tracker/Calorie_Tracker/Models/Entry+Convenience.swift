//
//  Entry+Convenience.swift
//  Calorie_Tracker
//
//  Created by Joe on 5/3/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    convenience init(calories: Int16, date: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Double(calories)
        self.date = date
    }
}

//
//  Calorie+Convenience.swift
//  Calorie Counter
//
//  Created by Sal B Amer on 5/1/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(calories: Int16,
                     date: Date = Date(),
                     identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.identifier = identifier
        self.date = date
    }
    
    convenience init?(_ calorieRepresentation: CalorieRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Int16(calorieRepresentation.calories)
        self.identifier = identifier
        self.date = Date(timeIntervalSinceReferenceDate: calorieRepresentation.date)
    }
    
    var calorieRepresentation: CalorieRepresentation? {
        CalorieRepresentation(calories: Int(self.calories), date: self.date!.timeIntervalSinceReferenceDate, identifier: self.identifier)
    }
}

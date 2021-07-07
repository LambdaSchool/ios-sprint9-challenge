//
//  Calorie+Convenience.swift
//  Calories
//
//  Created by Simon Elhoej Steinmejer on 21/09/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation
import CoreData

extension Calorie
{
    convenience init(calories: Int16, id: String, date: Date, context: NSManagedObjectContext = CoreDataManager.shared.mainContext)
    {
        self.init(context: context)
        self.calories = calories
        self.identifier = id
        self.date = date
    }
    
    convenience init?(calorieRepresentation: CalorieRepresentation, context: NSManagedObjectContext)
    {
        self.init(context: context)
        self.identifier = calorieRepresentation.identifier
        self.calories = Int16(calorieRepresentation.calories)
        self.date = calorieRepresentation.date
    }
}

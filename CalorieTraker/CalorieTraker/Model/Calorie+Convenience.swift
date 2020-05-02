//
//  Calorie+Convenience.swift
//  CalorieTraker
//
//  Created by denis cedeno on 5/1/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    @discardableResult
    convenience init(calories: Int16,
                     date: Date,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.date = date
    }
    
    var calorieRepresentation: CalorieRepresentation? {
        guard let date = date else {
            return nil
        }
        return CalorieRepresentation(calories: calories, date: date)
    }
    
     @discardableResult
    convenience init(calorieRepresentation: CalorieRepresentation,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(calories: calorieRepresentation.calories, date: calorieRepresentation.date)
    }
    
}

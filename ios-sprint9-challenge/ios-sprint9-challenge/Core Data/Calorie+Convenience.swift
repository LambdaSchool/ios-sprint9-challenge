//
//  Calorie+Convenience.swift
//  ios-sprint9-challenge
//
//  Created by Conner on 9/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(amount: Int32,
                     date: Date = Date(),
                     context: NSManagedObjectContext = CoreDataManager.shared.mainContext) {
        self.init(context: context)
        self.amount = amount
        self.date = date
    }
    
    convenience init?(calorieRepresentation: CalorieRepresentation, context: NSManagedObjectContext) {
        self.init(amount: Int32(calorieRepresentation.amount), date: calorieRepresentation.date)
    }
}

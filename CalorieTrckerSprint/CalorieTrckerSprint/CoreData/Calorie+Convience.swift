//
//  Calorie+Convience.swift
//  CalorieTrckerSprint
//
//  Created by Elizabeth Wingate on 3/27/20.
//  Copyright © 2020 Elizabeth Wingate. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(calorie: Int16, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)

        self.calorie = calorie
        self.timestamp = timestamp
    }

//    convenience init(calorieRepresentation: CalorieRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        self.init(calorie: calorieRepresentation.calorie, context: context)
//    }
//
//    var calorieRepresentation: CalorieRepresentation? {
//        guard let timestamp = timestamp else { return nil }
//
//        return CalorieRepresentation(calorie: calorie, timestamp: timestamp)
//    }
}

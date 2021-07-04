//
//  CalorieIntake + Convenience.swift
//  CalorieTracker
//
//  Created by Julian A. Fordyce on 3/15/19.
//  Copyright © 2019 Julian A. Fordyce. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {
    
    convenience init(calories: Double, timestamp: Date = Date(), identifier: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
        self.identifier = identifier
    }
    
    convenience init?(calorieIntakeRepresentation: CalorieIntakeRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(calories: calorieIntakeRepresentation.calories, timestamp: calorieIntakeRepresentation.timestamp, identifier: calorieIntakeRepresentation.identifier, context: context)
    }
    
    var formattedTimeStamp: String? {
        guard let timestamp = timestamp else {
            return nil
        }
        return DateFormat.dateFormatter.string(from: timestamp)
    }
    
    
}

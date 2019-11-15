//
//  CalorieTracker+Convenience.swift
//  Calorie Tracker
//
//  Created by Jesse Ruiz on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData
// swiftlint:disable all

extension CalorieTracker {
    
    var calorieTrackerRepresentation: CalorieTrackerRepresentation? {
        
        guard let date = date,
            let identifier = identifier else { return nil }
        
        return CalorieTrackerRepresentation(date: date, calorie: calorie, identifier: identifier)
    }
    
    @discardableResult convenience init(date: Date = Date.init(timeIntervalSinceNow: 0), calorie: Int, identifier: UUID = UUID(), context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.date = date
        self.calorie = Int64(calorie)
        self.identifier = identifier
    }
    
    @discardableResult convenience init?(calorieTrackerRepresentation: CalorieTrackerRepresentation, context: NSManagedObjectContext) {
        
        self.init(date: calorieTrackerRepresentation.date,
                  calorie: Int(calorieTrackerRepresentation.calorie),
                  identifier: calorieTrackerRepresentation.identifier,
                  context: context)
    }
    
}

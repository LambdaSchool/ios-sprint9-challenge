//
//  CalorieEntry+Convenience.swift
//  CalorieTrackerSPRINT
//
//  Created by John Pitts on 7/5/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry { // if you get to stretch goals you'll need to make this Codable
    
    convenience init(calorie: Double, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)   // need to study this statement better, weird structure
        self.calorie = calorie
        self.timestamp = timestamp
    }
    
    
    
    
    
    
    
    
//    var calorieEntry: CalorieEntry? {
//
//        // I changed calorie to not be optional, so might not need this unless shifting back
//        //guard let calorie = calorie else { return nil }
//
//        return CalorieEntry(calorie: calorie)
//    }
    
    // really don't think I need a CalorieEntryRepresentation, bc I'm not using Firebase (yet, see strech)
    
//    convenience init?(calorieEntryRepresentation: CalorieEntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        //guard let timestamp = calorieEntryRepresentation.timestamp else {return nil }
//
//        self.init(calorie: calorieEntryRepresentation.calorie, timestamp: timestamp, context: context)
//    }
    
    // why did we unwrap name and priority here?  they aren't optionals
//    var calorieEntryRepresentation: CalorieEntryRepresentation? {
//        guard let calorie = calorie else {return nil}
//
//        return CalorieEntryRepresentation(calorie: calorie)
//    }
}

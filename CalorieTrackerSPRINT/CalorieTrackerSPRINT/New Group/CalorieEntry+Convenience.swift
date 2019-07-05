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
    
    convenience init(calorie: Int16, timestamp: Date = Date() context: NSManagedObjectContext = CoreDataStack.shared.maincontext) {
        
        self.init(context: context)   // need to study this statement better, weird structure
        self.calorie = calorie
        self.timestamp = timestamp
    }
    
    // really don't think I need a CalorieEntryRepresentation, bc I'm not using Firebase (yet, see strech)
}

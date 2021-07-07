//
//  CalorieEntry+Convenience.swift
//  CalorieTrackerSprintChallenge
//
//  Created by Alex Shillingford on 12/20/19.
//  Copyright © 2019 Alex Shillingford. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    var calorieEntryRepresentation: CalorieEntryRep? {
        guard let amount = amount,
            let timestamp = timestamp else { return nil }
        
        return CalorieEntryRep(amount: amount, timestamp: timestamp)
    }
    
    convenience init(amount: String, timestamp: Date, context: NSManagedObjectContext) {
        self.init(context: context)
        self.amount = amount
        self.timestamp = timestamp
    }
    
    convenience init?(calorieEntryRepresentation: CalorieEntryRep, context: NSManagedObjectContext) {
        self.init(amount: calorieEntryRepresentation.amount,
                  timestamp: calorieEntryRepresentation.timestamp,
                  context: context)
    }
}

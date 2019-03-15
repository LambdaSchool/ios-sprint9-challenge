//
//  Calorie+Convenience.swift
//  CalorieTraker
//
//  Created by Jocelyn Stuart on 3/15/19.
//  Copyright © 2019 JS. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    
    @discardableResult
    convenience init(amount: Double, timestamp: Date = Date(), identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.amount = amount
        self.timestamp = timestamp
        self.identifier = identifier
       
    }
    
    @discardableResult
    convenience init?(calorieRep: CalorieRepresentation, context: NSManagedObjectContext) {
        
        self.init(amount: calorieRep.amount, timestamp: calorieRep.timestamp, identifier: calorieRep.identifier, context: context)
    }

}

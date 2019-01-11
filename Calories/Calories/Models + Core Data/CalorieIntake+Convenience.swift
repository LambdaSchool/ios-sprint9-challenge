//
//  CalorieIntake+Convenience.swift
//  Calories
//
//  Created by Jason Modisett on 1/11/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {
    
    // MARK:- Convenience initializers
    
    // CGFloat
    convenience init(name: String,
                     amount: CGFloat,
                     timestamp: Date = Date(),
                     identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.name = name
        self.amount = Float(amount)
        self.timestamp = timestamp
    }
    
    // Float
    convenience init(name: String,
                     amount: Float,
                     timestamp: Date = Date(),
                     identifier: String = UUID().uuidString,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.name = name
        self.amount = Float(amount)
        self.timestamp = timestamp
    }
    
    
    // MARK:- Representation initializer
    
    convenience init?(calorieIntakeRepresentation: CalorieIntakeRepresentation,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(name: calorieIntakeRepresentation.name,
                  amount: calorieIntakeRepresentation.amount,
                  timestamp: calorieIntakeRepresentation.timestamp,
                  context: context)
    }
    
}

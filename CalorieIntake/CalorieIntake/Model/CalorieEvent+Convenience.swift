//
//  CalorieEvent+Convenience.swift
//  CalorieIntake
//
//  Created by Benjamin Hakes on 2/15/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEvent {
    convenience init(
                    numberOfCalories: Double,
                    identifier: UUID = UUID(),
                    timestamp: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context:context)
        self.numberOfCalories = numberOfCalories
        self.identifier = identifier
        self.timestamp = timestamp
        
    }
    
}

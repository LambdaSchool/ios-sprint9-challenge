//
//  CaloriesEntry+Convenience.swift
//  CalorieTracker
//
//  Created by Sean Acres on 8/23/19.
//  Copyright © 2019 Sean Acres. All rights reserved.
//

import Foundation
import CoreData

extension CaloriesEntry {
    
    convenience init(amount: Double,
                     timestamp: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.amount = amount
        self.timestamp = timestamp
    }
}

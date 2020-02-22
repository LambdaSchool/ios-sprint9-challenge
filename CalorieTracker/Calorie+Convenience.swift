//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_201 on 2/22/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(calorie: Int16,
                     timestamp: Date = Date(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.calorie = calorie
        self.timestamp = timestamp
    }
}

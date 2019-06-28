//
//  CalorieDataPoints.swift
//  CalorieTracker
//
//  Created by Sameera Roussi on 6/28/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
    
    convenience init(caloriesRecorded: Int, dateRecorded: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.caloriesRecorded = Int16(caloriesRecorded)
        self.dateRecorded = dateRecorded
    }
    
}

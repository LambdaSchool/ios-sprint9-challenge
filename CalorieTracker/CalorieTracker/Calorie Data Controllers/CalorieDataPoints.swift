//
//  CalorieDataPoints.swift
//  CalorieTracker
//
//  Created by Sameera Roussi on 6/28/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import Foundation
import CoreData

struct CalorieDataPoints {
    var  caloriesRecorded: Int16
    var dateRecorded: Date
    
    init(caloriesRecorded: Int16, dateRecorded: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.caloriesRecorded = caloriesRecorded
        self.dateRecorded = dateRecorded
    }
    
}

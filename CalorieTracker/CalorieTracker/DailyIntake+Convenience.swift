//
//  DailyIntake+Convenience.swift
//  CalorieTracker
//
//  Created by Daniela Parra on 10/26/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

extension DailyIntake {
    
    convenience init(calories: Int, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.calories = Int16(calories)
        self.date = date
    }
    
}

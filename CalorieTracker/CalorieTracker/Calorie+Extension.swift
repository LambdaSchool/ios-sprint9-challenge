//
//  Calorie+Extension.swift
//  CalorieTracker
//
//  Created by Vuk Radosavljevic on 9/21/18.
//  Copyright © 2018 Vuk. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    
    
    convenience init(calories: Int16, managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: managedObjectContext)
        self.calories = calories
        self.timestamp = Date()
    }
    
    
}

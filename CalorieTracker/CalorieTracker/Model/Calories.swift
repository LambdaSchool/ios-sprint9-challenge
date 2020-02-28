//
//  Calories.swift
//  CalorieTracker
//
//  Created by Aaron Cleveland on 2/28/20.
//  Copyright © 2020 Aaron Cleveland. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
    // Initializes a Calorie Object
    convenience init(calories: String, added: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.added = added
    }
    
    var date: String {
        guard let added = self.added else { return "" }
        
        let df = DateFormatter()
        df.dateFormat = "MMM d Y 'at' h:mm a"
        let date = df.string(from: added)
        return date
    }
}

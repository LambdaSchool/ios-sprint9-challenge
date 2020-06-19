//
//  Calories.swift
//  CalorieTracker
//
//  Created by Enzo Jimenez-Soto on 6/19/20.
//  Copyright © 2020 Enzo Jimenez-Soto. All rights reserved.
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

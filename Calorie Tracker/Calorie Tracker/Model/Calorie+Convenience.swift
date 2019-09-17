//
//  Calorie+Convenience.swift
//  Calorie Tracker
//
//  Created by Michael Stoffer on 9/14/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {    
    // Initializes a Calorie Object
    convenience init(calories: String, created: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.created = created
    }
    
    var date: String {
        guard let created = self.created else { return "" }
        
        let df = DateFormatter()
        df.dateFormat = "MMM d Y 'at' h:mm a"
        let date = df.string(from: created)
        return date
    }
}

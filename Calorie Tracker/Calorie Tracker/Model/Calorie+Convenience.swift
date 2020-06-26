//
//  Calorie+Convenience.swift
//  Calorie Tracker
//
//  Created by patelpra on 6/13/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    
    convenience init(calories: String, created: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.created = created
    }
        
    var date: String {
        guard let created = self.created else { return "" }
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MMM d Y 'at' h:mm a"
        let date = dateFormat.string(from: created)
        return date
        
    }
}

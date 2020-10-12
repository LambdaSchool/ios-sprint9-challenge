//
//  CalorieIntake+Convenience.swift
//  iosCalorieTrackrSprintChallenge
//
//  Created by BrysonSaclausa on 10/10/20.
//

import Foundation
import CoreData

extension CalorieIntake {
    
    
    
    @discardableResult convenience init(calories: Double,
                                     timestamp: Date,
                                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
        
        var dateAdded: String {
            let dateAdded = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MMM d Y 'at' h:mm a"
            let date = dateformatter.string(from: dateAdded)
            return date
        }
    }
}

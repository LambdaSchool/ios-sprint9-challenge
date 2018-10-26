//
//  CalorieData+Convenience.swift
//  CalorieTracker
//
//  Created by Dillon McElhinney on 10/26/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreData

extension CalorieData {
    
    convenience init(calories: Double, timestamp: Date, id: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.timestamp = timestamp
        self.id = id
        
    }
    
    var formattedTimestamp: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        
        if let timestamp = timestamp {
            return dateFormatter.string(from: timestamp)
        } else {
            return ""
        }
    }
}

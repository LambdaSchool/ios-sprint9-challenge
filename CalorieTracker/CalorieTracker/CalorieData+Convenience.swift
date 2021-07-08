//
//  CalorieData+Convenience.swift
//  CalorieTracker
//
//  Created by Sean Hendrix on 1/11/19.
//  Copyright © 2019 Sean Hendrix. All rights reserved.
//

import Foundation
import CoreData

extension CalorieData {
    
    convenience init(calories: Double, person: Person?, timestamp: Date, id: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = calories
        self.person = person
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

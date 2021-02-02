//
//  User+Convenience.swift
//  CalorieTracker
//
//  Created by Sammy Alvarado on 10/11/20.
//

import Foundation
import CoreData

extension Users {
    
    var userRepresentation: UserRepresentation? {
        guard let time = time else { return nil }
        return UserRepresentation(calories: Int(calories),
                                  time: time )
    }
    
    @discardableResult convenience init(time: Date = Date(),
                                        calories: Int16,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
        self.init(context: context)
        self.time = time
        self.calories = calories
    }
}


//
//  User+Convenience.swift
//  CalorieTracker
//
//  Created by Sammy Alvarado on 10/11/20.
//

import Foundation
import CoreData

extension Users {

//     Getting a representation from a task
    var userRepresentation: UserRepresentation? {
        guard let time = time else { return nil }

        return UserRepresentation(calories: calories,
                                  time: time)
    }

    @discardableResult convenience init(identifier: UUID = UUID(),
                                        calories: Double,
                                        time: Date,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
        self.init(context: context)
        self.calories = calories
        self.time = time// it defualts to the case value as a string value
    }


    // Turn Task rep into a Task object
    @discardableResult convenience init?(userRespresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
    
        self.init(calories: userRespresentation.calories,
                  time: userRespresentation.time,
                  context: context)
    }
}

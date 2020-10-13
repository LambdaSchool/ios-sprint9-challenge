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
        
        return UserRepresentation(id: id?.uuidString ?? "",
                                  calories: calories,
                                  time: time ?? Date())
    }
    
    @discardableResult convenience init(id: UUID = UUID(),
                                        time: Date,
                                        calories: Double,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext
    ) {
        self.init(context: context)
        self.id = id
        self.time = time
    }
    
    @discardableResult convenience init?(userRespresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        guard let id = UUID(uuidString: userRespresentation.id) else { return nil }
        
        self.init(id: id,
                  time: userRespresentation.time,
                  calories: userRespresentation.calories,
                  context: context)
    }
}


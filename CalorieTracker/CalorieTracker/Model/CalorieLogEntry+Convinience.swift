//
//  CalorieLogEntry+Convinience.swift
//  CalorieTracker
//
//  Created by Zachary Thacker on 10/12/20.
//

import Foundation
import CoreData

extension CalorieLog {
    
    var representation: LogRepresentation? {
        guard let date = date else { return nil }
        return LogRepresentation(id: id?.uuidString ?? "", calories: Int(calories ?? 0), date: date)
        
    }
    
    
    @discardableResult convenience init(id: UUID = UUID(),
                                        calories: Int,
                                        date: Date = Date(),
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.id = id
        self.calories = Int64(calories)
        self.date = date
    }
    
    @discardableResult convenience init? (representation: LogRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let id = UUID(uuidString: representation.id) else { return nil}
        
        self.init(id: id,
                  calories: representation.calories,
                  date: representation.date,
                  context: context)
        
    }






}
//    @discardableResult convenience init?(representation: LogRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//
//                  self.init(id: representation.id,
//                  calories: representation.calories,
//                  date: representation.date)
//
//    }
//    var representation: LogRepresentation? {
//        guard let id = UUID(uuidString: self.id) else { return nil }
//
//                return LogRepresentation(id: Int(id),
//                                 calories: Int(calories),
//                                 date: String(date))
//    }
//}

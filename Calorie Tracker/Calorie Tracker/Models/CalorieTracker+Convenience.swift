//
//  CalorieTracker+Convenience.swift
//  Calorie Tracker
//
//  Created by Niranjan Kumar on 12/20/19.
//  Copyright © 2019 Nar Kumar. All rights reserved.
//

import Foundation
import CoreData


extension CalorieTracker {
    
    var calorieRepresentation: CalorieRepresentation? {
        
        guard let calorie = calorie,
            let date = date,
            let id = id else { return nil }
        
        return CalorieRepresentation(calorie: calorie, date: date, id: id)
    }
    
    @discardableResult convenience init(calorie: String, date: Date, id: UUID = UUID(), context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        self.calorie = calorie
        self.date = date
        self.id = id
        
    }
    
//    @discardableResult convenience init?(calorieRepresentation: CalorieRepresentation, context: NSManagedObjectContext) {
//        
//        self.init(calorie: calorieRepresentation.calorie,
//                  date: calorieRepresentation.date,
//                  id: calorieRepresentation.id,
//                  context: context)
//    }
    
    
}


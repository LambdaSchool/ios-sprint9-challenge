//
//  CalorieCount.swift
//  CalorieTracker
//
//  Created by Kat Milton on 8/23/19.
//  Copyright © 2019 Kat Milton. All rights reserved.
//

import Foundation
import CoreData

extension CalorieCount {
    
    @discardableResult convenience init(intakeNumber: String, date: Date? = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.intakeNumber = intakeNumber
        self.date = date
    }
    
    @discardableResult convenience init?(calorieCountRepresentation: CalorieCountRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.intakeNumber = calorieCountRepresentation.intakeNumber
        self.date = calorieCountRepresentation.date
    }
    
    var calorieCountRepresentation: CalorieCountRepresentation {
        return CalorieCountRepresentation(intakeNumber: intakeNumber, date: date)
    }
    
}

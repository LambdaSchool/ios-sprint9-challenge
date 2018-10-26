//
//  Calories+Convinience.swift
//  Calorie Tracker
//
//  Created by Ilgar Ilyasov on 10/26/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
    
    convenience init(amount: Int16, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.amount = amount
        self.date = date
    }
    
    convenience init?(caloriesRepresentation: CaloriesRepresentation, context: NSManagedObjectContext) {
        self.init(amount: Int16(caloriesRepresentation.amount), date: caloriesRepresentation.date, context: context)
    }
}

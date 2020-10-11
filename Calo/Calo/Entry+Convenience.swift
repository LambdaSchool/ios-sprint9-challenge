//
//  Entry+Convenience.swift
//  Calo
//
//  Created by Gladymir Philippe on 10/11/20.
//  Copyright © 2020 Gladymir Philippe. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    @discardableResult convenience init(calorieAmount: String, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calorieAmount = calorieAmount
        self.date = date
    }
    
    var dateAdded: String {
        guard let dateAdded = self.date else { return "" }
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d Y 'at' h:mm a"
        let date = dateformatter.string(from: dateAdded)
        return date
    }
}

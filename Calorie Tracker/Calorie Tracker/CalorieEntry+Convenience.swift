//
//  CalorieEntry+Convenience.swift
//  Calorie Tracker
//
//  Created by Moin Uddin on 10/26/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
    convenience init(amount: Int16, date: Date = Date(), context: NSManagedObjectContext =  CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.amount = amount
        self.date = date
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d Y, h:mm a"
        let date = dateFormatter.string(from: (self.date)!)
        return date
    }
    
}

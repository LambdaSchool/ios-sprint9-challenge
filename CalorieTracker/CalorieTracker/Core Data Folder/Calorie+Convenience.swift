//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Michael Flowers on 9/15/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(amount: String, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context: context)
        self.amount = amount
        self.date = date
    }
}

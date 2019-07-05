//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Michael Flowers on 7/5/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    convenience init(amount: Int, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext){
        self.init(context: context)
        self.amount = amount
        self.date = date
    }
}

//
//  Calories+Convenience.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_214 on 10/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
    
    convenience init(_ count: Int, _ date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calories = Int64(count)
        self.datetimestamp = date
    }
    
}

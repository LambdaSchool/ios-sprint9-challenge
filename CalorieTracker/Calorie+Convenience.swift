//
//  Calorie+Convenience.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_201 on 2/22/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
//

import Foundation
import CoreData

extension Track {
    convenience init(caloriesCount: String, date: Date = Date(), id: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.date = date
        self.id = id
        self.caloriesCount = caloriesCount
    }
}

//
//  Entry+Convenience.swift
//  CalorieTracker
//
//  Created by Shawn James on 5/22/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import Foundation
import CoreData

extension Entry {
    @discardableResult convenience init(calorieAmount: Int64,
                                        timeStamp: String,
                                        context: NSManagedObjectContext = CoreDataManager.shared.mainContext) {
        self.init(context: context)
        self.calorieAmount = calorieAmount
        self.timeStamp = timeStamp
    }

}

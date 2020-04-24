//
//  Calorie+Conv.swift
//  Cal_Tracker
//
//  Created by Lydia Zhang on 4/24/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
     @discardableResult convenience init(calorie: Int16,
                                         time: Date = Date(),
                                         context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.calorie = calorie
        self.time = time
    }
}

//
//  Calorie + Convenience.swift
//  CalorieTracker
//
//  Created by Lambda_School_loaner_226 on 8/14/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {
    @discardableResult convenience init(recordedCalories: Double, timeRecorded: Date = Date(), context: NSManagedObjectContext = CoreDataStack.coreData.mainContext) {
        self.init(context: context)
        self.recordedCalories = recordedCalories
        self.timeRecorded = timeRecorded
        
    }
}

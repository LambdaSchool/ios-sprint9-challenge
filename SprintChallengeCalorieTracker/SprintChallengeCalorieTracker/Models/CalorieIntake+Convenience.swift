//
//  CalorieIntake+Convenience.swift
//  SprintChallengeCalorieTracker
//
//  Created by morse on 12/20/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation
import CoreData

extension CalorieIntake {
    @discardableResult convenience init(calorieCount: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)

        self.calorieCount = Int16(calorieCount)
        self.date = Date()
        
        NotificationCenter.default.post(name: .calorieIntakeAdded, object: nil)
    }
}

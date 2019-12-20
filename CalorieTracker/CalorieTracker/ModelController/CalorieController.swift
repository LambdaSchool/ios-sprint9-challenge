//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by brian vilchez on 12/20/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    func createIntake(withCalories calories: Double) {
        _ = Calorie(intake: calories)
        CoreDataStack.shared.context.saveChanges()
    }
}

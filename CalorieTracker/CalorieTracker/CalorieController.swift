//
//  CalorieController.swift
//  CalorieTracker
//
//  Created by Tobi Kuyoro on 24/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {

    var calorieEntries: [Calorie] = []

    @discardableResult func add(calories: Int16) -> Calorie {
        let calorieEntry = Calorie(calories: calories)
        calorieEntries.append(calorieEntry)
        CoreDataStack.shared.save()

        return calorieEntry
    }
}

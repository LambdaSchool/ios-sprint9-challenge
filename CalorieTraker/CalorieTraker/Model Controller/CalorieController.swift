//
//  CalorieController.swift
//  CalorieTraker
//
//  Created by denis cedeno on 5/1/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import Foundation
import CoreData

class CalorieController {
    var caloriePosts: [Calorie] = []

    @discardableResult
    func appendCalories(calories: Int16) -> Calorie {
        let caloriePost = Calorie(calories: calories, date: Date())
        caloriePosts.append(caloriePost)
        do {
            try CoreDataStack.shared.save(context: CoreDataStack.shared.mainContext)
        } catch {
            fatalError("Could not save calorie post: \(error)")
        }
        return caloriePost

    }
}

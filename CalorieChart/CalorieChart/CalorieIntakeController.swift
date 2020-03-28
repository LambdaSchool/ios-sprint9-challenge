//
//  CalorieIntakeController.swift
//  CalorieChart
//
//  Created by Diante Lewis-Jolley on 6/28/19.
//  Copyright © 2019 Diante Lewis-Jolley. All rights reserved.
//

import Foundation
import CoreData


class CalorieIntakeController {

    func create(calories: Double) {

        let _ =  ColorieIntake(calorie: calories)
        saveToPersistentStore()


    }


    func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }


    func delete(calorieIntake: ColorieIntake) {

        let moc = CoreDataStack.shared.mainContext
        moc.delete(calorieIntake)
        saveToPersistentStore()
    }
}

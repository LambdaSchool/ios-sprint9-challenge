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
    var chart: CalorieChart
    init(chart: CalorieChart = CalorieChart()) {
        self.chart = chart
    }
    func createIntake(withCalories calories: Double) {
        let calorie = Calorie(intake: calories)
        chart.createGraphWith(calorie: calorie.intake)
        CoreDataStack.shared.context.saveChanges()
    }
}

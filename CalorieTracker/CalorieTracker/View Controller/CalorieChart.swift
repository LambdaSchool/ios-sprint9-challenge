//
//  CalorieChart.swift
//  CalorieTracker
//
//  Created by Josh Kocsis on 8/14/20.
//

import UIKit
import SwiftChart
import CoreData

class CalorieChart: UIView {

    @IBAction func addCalories(_ sender: UIButton) {
        Tracker(calories: Int16.random(in: 1...400) * 5)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
        }
    }

}

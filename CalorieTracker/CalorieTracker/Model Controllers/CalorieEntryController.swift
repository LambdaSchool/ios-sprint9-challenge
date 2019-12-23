//
//  CalorieEntryController.swift
//  CalorieTracker
//
//  Created by Percy Ngan on 12/20/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

class CalorieEntryController {
	var calorieEntries: [CalorieEntry] = []

	func saveCalorieEntryToPersistentStore() {

		let moc = CoreDataStack.shared.mainContext
				do {
					try moc.save()
				} catch {
					NSLog("Error saving managed object context: \(error)")
				}
	}

	func addCalorieEntry(numberOfCalories: Double) {

		_ = CalorieEntry(numberOfCalories: numberOfCalories)
		saveCalorieEntryToPersistentStore()
	}

	func deleteCalorieEntry(calorieEntry: CalorieEntry) {
		
		let moc = CoreDataStack.shared.mainContext
		moc.delete(calorieEntry)
		saveCalorieEntryToPersistentStore()
	}
}

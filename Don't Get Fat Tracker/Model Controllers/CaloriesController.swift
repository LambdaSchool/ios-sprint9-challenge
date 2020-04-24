//
//  CaloriesController.swift
//  Don't Get Fat Tracker
//
//  Created by Michael Redig on 6/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation
import CoreData

class CaloriesController {

	func create(calories: Double, id: UUID = UUID(), person: User, timestamp: Date = Date()) {
		CoreDataStack.shared.mainContext.performAndWait {
			let calories = Calories(calories: calories, id: id, person: person.id, timestamp: timestamp)
			saveToPersistentStore(onContext: calories.managedObjectContext)
		}
	}

	func delete(calories: Calories) {
		guard let context = calories.managedObjectContext else { return }
		context.delete(calories)
		saveToPersistentStore(onContext: context)
	}

	func saveToPersistentStore(onContext context: NSManagedObjectContext?) {
		guard let context = context else {
			NSLog("Can't save to nil context.")
			return
		}
		do {
			try CoreDataStack.shared.save(context: context)
		} catch {
			NSLog("Error saving to context: \(error)")
		}
	}
}


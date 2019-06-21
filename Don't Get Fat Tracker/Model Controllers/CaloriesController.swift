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

	var primaryUser: UUID {
		get {
			let string = UserDefaults.standard.string(forKey: "primaryUser") ?? ""
			guard let user = UUID(uuidString: string) else {
				let newUser = UUID()
				UserDefaults.standard.set(newUser.uuidString, forKey: "primaryUser")
				return newUser
			}
			return user
		}
		set {
			UserDefaults.standard.set(newValue.uuidString, forKey: "primaryUser")
		}
	}

	func create(calories: Double, id: UUID = UUID(), timestamp: Date = Date()) {
		create(calories: calories, id: id, person: primaryUser, timestamp: timestamp)
	}
	
	func create(calories: Double, id: UUID = UUID(), person: UUID, timestamp: Date = Date()) {
		let calories = Calories(calories: calories, id: id, person: person, timestamp: timestamp)
		saveToPersistentStore(onContext: calories.managedObjectContext)
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

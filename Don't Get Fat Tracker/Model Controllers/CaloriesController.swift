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

	enum User: String {
		case primaryUser, secondaryUser, thirdaryUser
	}

	var primaryUser: UUID {
		get {
			return getIDForUser(user: .primaryUser)
		}
		set {
			UserDefaults.standard.set(newValue.uuidString, forKey: User.primaryUser.rawValue)
		}
	}

	var secondaryUser: UUID {
		get {
			return getIDForUser(user: .secondaryUser)
		}
		set {
			UserDefaults.standard.set(newValue.uuidString, forKey: User.secondaryUser.rawValue)
		}
	}

	var thirdaryUser: UUID {
		get {
			return getIDForUser(user: .thirdaryUser)
		}
		set {
			UserDefaults.standard.set(newValue.uuidString, forKey: User.thirdaryUser.rawValue)
		}
	}

	func getIDForUser(user: User) -> UUID {
		let string = UserDefaults.standard.string(forKey: user.rawValue) ?? ""
		guard let userID = UUID(uuidString: string) else {
			let newUser = UUID()
			UserDefaults.standard.set(newUser.uuidString, forKey: user.rawValue)
			return newUser
		}
		return userID
	}

	func create(calories: Double, id: UUID = UUID(), timestamp: Date = Date()) {
		create(calories: calories, id: id, person: primaryUser, timestamp: timestamp)
	}
	
	func create(calories: Double, id: UUID = UUID(), person: UUID, timestamp: Date = Date()) {
		CoreDataStack.shared.mainContext.performAndWait {
			let calories = Calories(calories: calories, id: id, person: person, timestamp: timestamp)
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

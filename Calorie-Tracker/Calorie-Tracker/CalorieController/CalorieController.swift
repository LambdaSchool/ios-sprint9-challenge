//
//  CalorieController.swift
//  Calorie-Tracker
//
//  Created by Marlon Raskin on 9/20/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
// swiftling:disable vertical_parameter_alignment

import Foundation
import CoreData

class CalorieController {

	private func sendCalorieHasBeenAddedNotification() {
		let notification = Notification(name: .calorieHasBeenAdded)
		NotificationCenter.default.post(notification)
	}

	func createCalorieEntry(amount: String, date: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		context.performAndWait {
			guard let amountFromStr = Int16(amount) else { return }
			CalorieEntry(amount: amountFromStr, date: date)
			do {
				try CoreDataStack.shared.save(context: context)
				sendCalorieHasBeenAddedNotification()
			} catch {
				NSLog("Error saving context when creating Calorie Entry: \(error)")
			}
		}
	}

	func deleteCalorieEntry(calorieEntry: CalorieEntry, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		context.performAndWait {
			let moc = CoreDataStack.shared.mainContext
			moc.delete(calorieEntry)
			do {
				try CoreDataStack.shared.save(context: context)
			} catch {
				NSLog("Error saving context when deleting Calorie Entry: \(error)")
			}
		}
	}

	func loadFromPersistentStore() -> [CalorieEntry] {
		let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
		let moc = CoreDataStack.shared.mainContext

		do {
			let calorieEntries = try moc.fetch(fetchRequest)
			return calorieEntries
		} catch {
			NSLog("Error fetching Calorie Entries: \(error)")
			return []
		}
	}
}

//
//  IntakeController.swift
//  CalorieTracker
//
//  Created by Jeffrey Santana on 9/20/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation

class IntakeController {
	
	//MARK: - Create
	
	func createIntake(calories: Double) {
		CoreDataStack.shared.mainContext.performAndWait {
			let newIntake = Intake(calories: calories)
			
			do {
				try CoreDataStack.shared.save()
				sendIntakesFetchedNotification()
				print("Intake Saved!")
			} catch {
				NSLog("Error saving context when creating a new task")
			}
		}
	}
	
	private func sendIntakesFetchedNotification() {
		let notification = Notification(name: .intakesFetched)
		NotificationCenter.default.post(notification)
	}
	
	//MARK: - Read
	
	
	//MARK: - Update
	
	
	//MARK: - Delete
	
	
}

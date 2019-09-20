//
//  CalorieEntry+Convenience.swift
//  Calorie-Tracker
//
//  Created by Marlon Raskin on 9/20/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
	@discardableResult convenience init(amount: Int16,
										date: Date = Date(),
										context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		self.amount = amount
		self.dateAdded = date
	}
}

//
//  Calories+Convenience.swift
//  Don't Get Fat Tracker
//
//  Created by Michael Redig on 6/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Foundation
import CoreData

extension Calories {
	convenience init(calories: Double, id: UUID = UUID(), person: Int64, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		self.calories = calories
		self.id = id
		self.person = person
		self.timestamp = timestamp
	}
}

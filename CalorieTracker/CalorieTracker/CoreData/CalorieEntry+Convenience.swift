//
//  CalorieEntry+Convenience.swift
//  CalorieTracker
//
//  Created by Percy Ngan on 12/20/19.
//  Copyright © 2019 Lamdba School. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {

	convenience init(numberOfCalories: Double, entryDate: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

		self.init(context: context)
		self.numberOfCalories = numberOfCalories
		self.entryDate = entryDate

	}
}

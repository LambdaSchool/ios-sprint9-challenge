//
//  Intake.swift
//  CalorieTracker
//
//  Created by Jeffrey Santana on 9/20/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreData

extension Intake {
	convenience init(calories: Double, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		
		self.calories = calories
		self.timestamp = timestamp
	}
}

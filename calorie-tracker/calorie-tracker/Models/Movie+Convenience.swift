//
//  Movie+Convenience.swift
//  calorie-tracker
//
//  Created by Hector Steven on 6/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation
import CoreData


extension Track {
	convenience init (caloriesCount: String, date: Date = Date(), id: String = UUID().uuidString, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
		self.init(context: context)
		self.date = date
		self.id = id
		self.caloriesCount = caloriesCount
	}
	
	
}



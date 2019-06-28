//
//  CalorieTrackerController.swift
//  calorie-tracker
//
//  Created by Hector Steven on 6/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation
import CoreData

class CalorieTrackerController {
	
	func save() throws {
		try shared.save(context: shared.mainContext)
	}
	
	
	
	func deleteAll () {
		let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
		
		var result: [Track] =  []
		let context = shared.mainContext
		
		context.performAndWait {
			do {
				result = try context.fetch(fetchRequest)
				print(result.count)
				
			} catch {
				NSLog("Error fetching results from store: \(error)")
			}
		}
		
	}
	
	init(shared: CoreDataStack = CoreDataStack.shared) {
		self.shared = shared
		deleteAll()
	}
	
	private let shared: CoreDataStack
}

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
	
	func fetchTracks() -> [Track] {
		let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
		
		var result: [Track] =  []
		let context = shared.mainContext
		
		context.performAndWait {
			do {
				result = try context.fetch(fetchRequest)
				print(result)
				
			} catch {
				NSLog("Error fetching results from store: \(error)")
			}
		}
		return result
	}
	
	
	func deleteAll () {
		let tracks = fetchTracks()
		for track in tracks {
			shared.mainContext.delete(track)
		}
	}
	
	
	
	init(shared: CoreDataStack = CoreDataStack.shared) {
		self.shared = shared
		trackedCalories = fetchTracks()
	}
	
	private let shared: CoreDataStack
	private (set) var trackedCalories: [Track] = []
}

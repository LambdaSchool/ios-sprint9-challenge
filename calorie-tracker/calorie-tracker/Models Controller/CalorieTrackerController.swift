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
	
	func save(_ track: Track) throws {
		try shared.save(context: shared.mainContext)
		trackedCalories.append(track)
	}
	
	func fetchTracks() {
		let context = shared.mainContext
		let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
		let fetchResultController =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
		
		context.performAndWait {
			do {
				try fetchResultController.performFetch()
				trackedCalories = fetchResultController.fetchedObjects ??  []
				
			} catch {
				NSLog("Error fetching results from store: \(error)")
			}
		}
	}
	
	
	func deleteAll () {
		let context = shared.mainContext
		let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
		let fetchResultController =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
		
		context.performAndWait {
			do {
				try fetchResultController.performFetch()
				trackedCalories = fetchResultController.fetchedObjects ??  []
				for track in trackedCalories {
					context.delete(track)
					trackedCalories = []
				}
			} catch {
				NSLog("Error fetching results from store: \(error)")
			}
		}
	}
	
	
	
	init(shared: CoreDataStack = CoreDataStack.shared) {
		self.shared = shared
		deleteAll()
	}
	
//	var fetchResultController: NSFetchedResultsController<Track> {
//		let fetchRequest: NSFetchRequest<Track> = Track.fetchRequest()
//		fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
//		return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
//	}
	
	private let shared: CoreDataStack
	private (set) var trackedCalories: [Track] = []
}

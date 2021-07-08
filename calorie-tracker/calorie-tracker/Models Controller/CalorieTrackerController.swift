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
		try? shared.mainContext.save()
	}
	
	
	
	init(shared: CoreDataStack = CoreDataStack.shared) {
		self.shared = shared
	}
	
	var getXLabels: [Double] {
		guard !trackedCalories.isEmpty else  { return [0] }
		var arr: [Double] = []
		for i in 0...trackedCalories.count - 1 {
			arr.append(Double(i))
		}
		return arr
	}
	
	var getYLabels: [Double] {
		guard !trackedCalories.isEmpty else  { return [0] }
		var big: Double = 0
		let first: Double = Double(trackedCalories[0].caloriesCount!)!
		for t in trackedCalories {
			guard let i = Int(t.caloriesCount!) else { return [0]}
			if  Double(i) > big { big = Double(i) }
		}
		
		return [first, big/2, big]
	}
	
	var getData: [(x: Double, y: Double)] {
		var data: [(x: Double, y: Double)] = []
		
		for (i, calories) in trackedCalories.enumerated() {
			if let y = Double(calories.caloriesCount!) {
				data.append((x: Double(i), y: y))
			}
		}
		
		return data
	}
	
	private let shared: CoreDataStack
	private (set) var trackedCalories: [Track] = []
}

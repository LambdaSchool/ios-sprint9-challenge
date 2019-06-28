//
//  CoreDataStack.swift
//  calorie-tracker
//
//  Created by Hector Steven on 6/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
	static let shared = CoreDataStack()
	
	func save(context: NSManagedObjectContext) throws {
		var error: Error?
		
		context.performAndWait {
			do {
				try context.save()
			} catch let saveError {
				NSLog("Error saving moc: \(saveError)")
				error = saveError
			}
		}
		
		if let error = error { throw error }
	}
	
	lazy var container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Track")
		container.loadPersistentStores { _, error in
			if let error = error {
				fatalError("Failed to load presistent store: \(error)")
			}
		}
		return container
	}()
	
	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}
}

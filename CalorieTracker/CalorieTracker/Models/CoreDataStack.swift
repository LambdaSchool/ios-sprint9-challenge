//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by Jeffrey Santana on 9/20/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
	static let shared = CoreDataStack()
	
	lazy var container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: .calorieTrackerKey)
		
		container.viewContext.automaticallyMergesChangesFromParent = true
		container.loadPersistentStores(completionHandler: { (_, error) in
			guard let error = error else { return }
			fatalError("Failed to load persistent store(s): \(error)")
		})
		return container
	}()
	
	var mainContext: NSManagedObjectContext {
		return container.viewContext
	}
	
	func save(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) throws {
		try context.save()
	}
}

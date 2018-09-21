//
//  CoreDataStack.swift
//  CalorieTracker
//
//  Created by William Bundy on 9/21/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack
{
	static let shared = CoreDataStack()
	lazy var container:NSPersistentContainer = {
		let con = NSPersistentContainer(name:"CalorieTracker")
		con.loadPersistentStores { _, error in
			if let error = error {
				NSLog("Failed to load persistent store")
				fatalError()
			}
		}

		con.viewContext.automaticallyMergesChangesFromParent = true

		return con
	}()

	var mainContext:NSManagedObjectContext { return container.viewContext }
}

extension NSManagedObjectContext {

	@discardableResult
	func safeSave(withReset:Bool = true) -> Bool
	{
		var didSave = true
		self.performAndWait {
			do {
				try self.save()
			} catch {
				NSLog("Failed to save managed object context: \(error)")
				if withReset {
					self.reset()
				}
				didSave = false
			}
		}
		return didSave
	}
}


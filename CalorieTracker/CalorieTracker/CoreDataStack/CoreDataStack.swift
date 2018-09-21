
import Foundation
import UIKit
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


import Foundation
import UIKit
import CoreData

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

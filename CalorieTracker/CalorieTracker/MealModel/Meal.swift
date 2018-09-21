
import Foundation
import UIKit
import CoreData

extension Meal
{
	convenience init(_ calories:Int,
					 _ person:String,
					 timestamp:Date=Date(),
					 uuid:UUID=UUID(),
					 moc:NSManagedObjectContext=CoreDataStack.shared.mainContext)
	{
		self.init(context:moc)
		self.calories = Int32(calories)
		self.person = person
		self.timestamp = timestamp
		self.identifier = uuid
	}

	convenience init(_ meal:MealStub, moc:NSManagedObjectContext=CoreDataStack.shared.mainContext)
	{
		self.init(context:moc)
		applyStub(meal)
	}

	func applyStub(_ meal:MealStub)
	{
		self.calories = Int32(meal.calories)
		self.person = meal.person
		self.timestamp = meal.timestamp
		self.identifier = meal.identifier
	}

	func getStub() -> MealStub
	{
		return MealStub(
			calories: Int(calories),
			person: person ?? "Unknown",
			timestamp: timestamp ?? Date(),
			identifier: identifier ?? UUID())
	}

	static func ==(l:Meal, r:Meal) -> Bool
	{
		return l.identifier == r.identifier
	}

	static func <(l:Meal, r:Meal) -> Bool
	{
		guard let lp = l.person, let rp = r.person else { return l.calories < r.calories }

		guard let lt = l.timestamp,
			let rt = r.timestamp else {
				return lp < rp
		}

		if lp == rp {
			return lt < rt
		}
		// alphabetically!
		return lp < rp
	}
}

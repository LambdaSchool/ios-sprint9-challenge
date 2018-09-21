
import Foundation
import UIKit
import CoreData

class MealController
{
	let MealChanged = NSNotification.Name("com.wb.MealChangedNotification")
	static var shared = MealController()

	var meals:[String:[MealStub]] = [:]

	func loadMeals()
	{
		let moc = CoreDataStack.shared.mainContext
		moc.performAndWait {
			let req:NSFetchRequest<Meal> = Meal.fetchRequest()
			req.sortDescriptors = [
				NSSortDescriptor(key: "person", ascending: false)
			]
			do {
				let localMeals = try moc.fetch(req)
				for meal in localMeals {
					fastInsertMeal(meal.getStub())
				}

				for person in meals.keys {
					meals[person]?.sort()
				}
			} catch {
				NSLog("Couldn't fetch existing meals: \(error)")
			}
		}
	}

	private func fastInsertMeal(_ stub:MealStub)
	{
		if meals[stub.person] != nil {
			meals[stub.person]?.append(stub)
		} else {
			meals[stub.person] = [stub]
		}
	}

	private func insertMeal(_ stub:MealStub)
	{
		// does this person exist?
		if let list = meals[stub.person] {
			// if we're updating an existing meal
			if let index = list.index(of: stub) {
				meals[stub.person]?[index] = stub
			} else {
				// otherwise, append
				meals[stub.person]?.append(stub)
			}

			meals[stub.person]?.sort()
		} else {
			meals[stub.person] = [stub]
		}

		let nc = NotificationCenter.default
		nc.post(name: MealChanged, object: meals[stub.person] ?? [])
	}

	private func removeMeal(_ stub:MealStub)
	{
		if let list = meals[stub.person] {
			if let index = list.index(of: stub) {
				meals[stub.person]?.remove(at: index)
			}
			meals[stub.person]?.sort()
			let nc = NotificationCenter.default
			nc.post(name: MealChanged, object: meals[stub.person] ?? [])
		}
	}

	@discardableResult
	func create(_ calories:Int,
				_ person:String,
				timestamp:Date=Date(),
				uuid:UUID=UUID(),
				moc:NSManagedObjectContext=CoreDataStack.shared.mainContext) -> Meal
	{
		var meal:Meal?
		moc.performAndWait {
			meal = Meal(calories, person, timestamp:timestamp, uuid:uuid, moc:moc)
			insertMeal(meal!.getStub())
			self.save(moc:moc)
		}
		return meal!
	}

	@discardableResult
	func create(_ stub:MealStub,
				moc:NSManagedObjectContext=CoreDataStack.shared.mainContext) -> Meal
	{
		var meal:Meal?
		moc.performAndWait {
			meal = Meal(stub, moc:moc)
			insertMeal(meal!.getStub())
			self.save(moc:moc)
		}
		return meal!
	}

	@discardableResult
	func save(moc:NSManagedObjectContext=CoreDataStack.shared.mainContext, withReset:Bool = true) -> Bool
	{
		// TODO: send notification

		return moc.safeSave(withReset: withReset)
	}

	func update(_ meal:Meal, _ stub:MealStub)
	{
		guard let moc = meal.managedObjectContext else { NSLog("Meal didn't have a moc?"); return }
		moc.performAndWait {
			meal.applyStub(stub)
			insertMeal(meal.getStub())
			self.save(moc:moc)
		}
	}

	func findAndUpdate(_ stub:MealStub, moc:NSManagedObjectContext=CoreDataStack.shared.mainContext) -> Meal?
	{
		var meal:Meal?
		moc.performAndWait {
			let req:NSFetchRequest<Meal> = Meal.fetchRequest()
			req.predicate = NSPredicate(format: "identifier == %@", stub.identifier as NSUUID)
			do {
				meal = try moc.fetch(req).first
			} catch {
				NSLog("Could not find meal with identifier: \(stub.identifier)")
				return
			}

			if let meal = meal {
				meal.applyStub(stub)
				insertMeal(meal.getStub())
				self.save(moc:moc)
			} else {
				meal = self.create(stub, moc:moc)
			}
		}
		return meal
	}

	func delete(_ meal:Meal)
	{
		guard let moc = meal.managedObjectContext else { NSLog("Meal didn't have a moc?"); return }
		moc.performAndWait {
			removeMeal(meal.getStub())
			moc.delete(meal)
			self.save(moc:moc)
		}
	}
}

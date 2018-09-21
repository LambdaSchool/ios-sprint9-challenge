
import Foundation
import UIKit
import CoreData

struct MealStub: Equatable, Comparable, Codable
{
	var calories:Int
	var person:String
	var timestamp:Date
	var identifier:UUID

	static func ==(l:MealStub, r:MealStub) -> Bool
	{
		return l.identifier == r.identifier
	}

	static func <(l:MealStub, r:MealStub) -> Bool
	{
		if l.person == r.person {
			return l.timestamp < r.timestamp
		}
		// alphabetically!
		return l.person < r.person
	}
}

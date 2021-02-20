//
//  Calories+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by John McCants on 2/19/21.
//  Copyright © 2021 John McCants. All rights reserved.
//
//

import Foundation
import CoreData


extension Calories {

        var calorieRepresentation: CaloriesRepresentation? {
            guard let timestamp = timestamp else {return nil}
            return CaloriesRepresentation(calories: Int(calories), timestamp: timestamp)
        }
        @nonobjc public class func fetchRequest() -> NSFetchRequest<Calories> {
            return NSFetchRequest<Calories>(entityName: "Calories")
        }

        @NSManaged public var calories: Int16
        @NSManaged public var timestamp: Date?

        @discardableResult convenience init(calories: Int, timestamp: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            self.init(context: context)
            self.calories = Int16(calories)
            self.timestamp = timestamp
        }

}

extension Calories: Identifiable {

}

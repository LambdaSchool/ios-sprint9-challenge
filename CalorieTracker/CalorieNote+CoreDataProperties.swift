//
//  CalorieNote+CoreDataProperties.swift
//  CalorieTracker
//
//  Created by John Kouris on 12/14/19.
//  Copyright © 2019 John Kouris. All rights reserved.
//
//

import Foundation
import CoreData


extension CalorieNote {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CalorieNote> {
        return NSFetchRequest<CalorieNote>(entityName: "CalorieNote")
    }

    @NSManaged public var date: Date?
    @NSManaged public var calories: String?

}

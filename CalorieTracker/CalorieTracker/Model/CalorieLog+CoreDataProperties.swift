//
//  CalorieLog+CoreDataProperties.swift
//  
//
//  Created by Zachary Thacker on 10/12/20.
//
//

import Foundation
import CoreData


extension CalorieLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CalorieLog> {
        return NSFetchRequest<CalorieLog>(entityName: "CalorieLog")
    }

    @NSManaged public var calories: Int64
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?

}

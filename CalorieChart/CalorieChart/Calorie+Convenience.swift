//
//  Calorie+Convenience.swift
//  CalorieChart
//
//  Created by Diante Lewis-Jolley on 6/28/19.
//  Copyright © 2019 Diante Lewis-Jolley. All rights reserved.
//

import Foundation
import CoreData

extension ColorieIntake {

    convenience init(identifier: String = UUID().uuidString, timeStamp: Date = Date(), calorie: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {

        self.init(context: context)
        self.identifier = identifier
        self.calorie = calorie
        self.timeStamp = timeStamp
    }
}

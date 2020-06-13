//
//  CalorieEntry+Convenience.swift
//  CalorieTracker
//
//  Created by Chad Parker on 6/12/20.
//  Copyright © 2020 Chad Parker. All rights reserved.
//

import Foundation
import CoreData

extension CalorieEntry {
   
   @discardableResult convenience init(calories: Int16,
                                       date: Date = Date(),
                                       context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
      self.init(context: context)
      self.calories = calories
      self.date = date
   }
}

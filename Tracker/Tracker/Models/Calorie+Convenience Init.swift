//
//  Calrorie+ConvenienceInit.swift
//  Tracker
//
//  Created by Nick Nguyen on 2/10/21.
//  Copyright © 2021 Nick Nguyen. All rights reserved.
//

import CoreData

extension Calorie {
  @discardableResult convenience init(calories: Int,
                                      timestamp: Date,
                                      context: NSManagedObjectContext) {
    self.init(context: context)
    self.amount = Int64(calories)
    self.date = timestamp
  }
}

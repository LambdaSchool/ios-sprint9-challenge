//
//  Calorie.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_268 on 4/24/20.
//  Copyright © 2020 Lambda. All rights reserved.
//

import Foundation
import CoreData

extension Calorie {

    convenience init(amount: String, timeAdded: Date = Date(), context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.amount = amount
        self.timeAdded = timeAdded
    }

    var date: String {
        guard let timeAdded = self.timeAdded else { return "" }

        let df = DateFormatter()
        df.dateFormat = "MM dd Y 'at' h:mm"
        let date = df.string(from: timeAdded)
        return date
    }
}

extension Notification.Name {
    static let updateChart = Notification.Name("updateChart")
}

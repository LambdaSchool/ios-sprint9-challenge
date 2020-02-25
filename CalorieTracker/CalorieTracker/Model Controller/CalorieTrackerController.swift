//
//  CalorieTrackerController.swift
//  CalorieTracker
//
//  Created by Craig Swanson on 2/23/20.
//  Copyright © 2020 Craig Swanson. All rights reserved.
//

import Foundation
import CoreData
import SwiftChart

class CalorieTrackerController {
    
    func addEntry(entry: CalorieTracker, completion: @escaping () -> Void = { }) {
        
            try? CoreDataStack.shared.save()
        
        // Set a notification center post for observers
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: .addedCalorieEntry, object: nil)
        
    }
}

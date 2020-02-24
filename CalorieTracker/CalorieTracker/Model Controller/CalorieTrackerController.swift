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
    
    var entries: [CalorieTracker] = []
    
    func addEntry(entry: CalorieTracker, completion: @escaping () -> Void = { }) {
        entries.append(entry)
        do {
            try? CoreDataStack.shared.save()
        } catch {
            print("error in adding a new entry to core data \(error)")
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: .addedCalorieEntry, object: nil)
        
    }
    
    private func saveToPersistentStore() throws {
        let moc = CoreDataStack.shared.mainContext
        try moc.save()
    }
}

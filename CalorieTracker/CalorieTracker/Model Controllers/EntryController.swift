//
//  EntryController.swift
//  CalorieTracker
//
//  Created by Bobby Keffury on 12/13/19.
//  Copyright © 2019 Bobby Keffury. All rights reserved.
//

import Foundation

class EntryController {
    
    // Need to change this to an array of Entries.
    var entries: [Entry] = []
    
    func createEntry(with calories: String) {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        let timestamp = formatter.string(from: currentDateTime)
        
        let entry = Entry(calories: calories, timestamp: timestamp)
        entries.append(entry)
    }
}

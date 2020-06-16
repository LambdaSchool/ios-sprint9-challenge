//
//  CalorieTrackerTableViewCell.swift
//  CalorieTracker
//
//  Created by Kevin Stewart on 6/12/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

class CalorieTrackerTableViewCell: UITableViewCell {
    
    var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateStyle = .short
       formatter.timeStyle = .short
        formatter.dateFormat = "MMM d, yyyy, h:mm a"
       return formatter
    }()
    
    // Outlets
    @IBOutlet var calorieLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    
    var calories: Calories? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        calorieLabel.text = "Calories \(calories?.calories ?? Int16(100))"
        timestampLabel.text = dateFormatter.string(from: calories?.timestamp ?? Date())
    }
    
}

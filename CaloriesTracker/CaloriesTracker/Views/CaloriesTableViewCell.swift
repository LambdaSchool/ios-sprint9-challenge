//
//  CaloriesTableViewCell.swift
//  CaloriesTracker
//
//  Created by Bhawnish Kumar on 5/22/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class CaloriesTableViewCell: UITableViewCell {
    
    var calories: Calories? {
        didSet {
            updatesViews()
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    func updatesViews() {
        guard let calories = calories else { return }
        
        let dateString = dateFormatter.string(from: calories.timestamp!)
        let timeString = timeFormatter.string(from: calories.timestamp!)
        timestampLabel.text = "\(dateString) at \(timeString)"
        calorieLabel.text = "Calories: \(calories.calories)"
        
    }
    
}

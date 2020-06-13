//
//  CalorieTrackerTableViewCell.swift
//  CalorieTracker
//
//  Created by Kevin Stewart on 6/12/20.
//  Copyright © 2020 Kevin Stewart. All rights reserved.
//

import UIKit

class CalorieTrackerTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet var calorieLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    
    var calories: Calories? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        calorieLabel.text = "Calories \(String(describing: calories?.calories))"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm:ss a"
        
        timestampLabel.text = "\(String(describing: calories?.timestamp))"
    }
    
}

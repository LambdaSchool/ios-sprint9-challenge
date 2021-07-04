//
//  CalorieTableViewCell.swift
//  Calorie Tracker
//
//  Created by Madison Waters on 10/27/18.
//  Copyright © 2018 Jonah Bergevin. All rights reserved.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var CalorieInputLabel: UILabel!
    @IBOutlet weak var TimestampLabel: UILabel!
    
    private func updateViews(){
        guard let calories = calories else { return }
        
        CalorieInputLabel.text = calories.value
        TimestampLabel.text = TimestampFormatter.formatTimestamp(for: calories)
        
    }
    
    var calories: Calories? {
        didSet {
            updateViews()
        }
    }
}

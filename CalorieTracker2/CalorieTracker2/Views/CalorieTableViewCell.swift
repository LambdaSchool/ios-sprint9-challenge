//
//  CalorieTableViewCell.swift
//  CalorieTracker2
//
//  Created by Stephanie Ballard on 6/19/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {
    
    var calorieTracker: CalorieTracker? {
        didSet {
            updateViews()
        }
    }
    
    let dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    @IBOutlet weak var caloriesTextLabel: UILabel!
    @IBOutlet weak var timestampTextLabel: UILabel!
    
    func updateViews() {
        guard let calorieTracker = calorieTracker,
            let timestamp = calorieTracker.timestamp else { return }
        
        caloriesTextLabel.text = "Calories: \(calorieTracker.calories)"
        let calorieTimestamp = dateFormatter.string(from: timestamp)
        timestampTextLabel.text = calorieTimestamp
    }
}

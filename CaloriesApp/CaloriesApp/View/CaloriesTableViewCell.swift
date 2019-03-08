//
//  CaloriesTableViewCell.swift
//  CaloriesApp
//
//  Created by Nelson Gonzalez on 3/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class CaloriesTableViewCell: UITableViewCell {
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var calories: Calories? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews() {
        
        guard let calories = calories else {return}
        calorieLabel.text = "Calories: \(String(Int(calories.calorieAmount)))"
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        if let date = calories.date {
            dateLabel.text = dateFormatter.string(from: date)
        }
    }
    

}

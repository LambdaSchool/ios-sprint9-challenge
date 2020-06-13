//
//  CellCalorieTrackerTableViewCell.swift
//  CalorieTrackerApp
//
//  Created by Jarren Campos on 6/12/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit

class CellCalorieTrackerTableViewCell: UITableViewCell {
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    @IBOutlet var calorieCountLabel: UILabel!
    @IBOutlet var calorieSavedDateLabel: UILabel!
    
    
        override func awakeFromNib() {
            super.awakeFromNib()
        }
        
        func setOption(calorie: CalorieEntry){
            calorieCountLabel.text = "Calories: \(calorie.calories)"
            calorieSavedDateLabel.text = dateFormatter.string(from: calorie.timestamp!)
        }

    }


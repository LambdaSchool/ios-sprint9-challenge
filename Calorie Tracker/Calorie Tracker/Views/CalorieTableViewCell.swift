//
//  CalorieTableViewCell.swift
//  Calorie Tracker
//
//  Created by Matthew Martindale on 6/14/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {
    
    var calorie: Calorie? {
        didSet {
            updateView()
        }
    }

    @IBOutlet weak var calorieCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func updateView() {
        if let calorie = calorie {
            calorieCountLabel.text = String(calorie.count)
            dateLabel.text = calorie.date?.toString()
        }
    }

}

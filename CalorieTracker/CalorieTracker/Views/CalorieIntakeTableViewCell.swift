//
//  CalorieIntakeTableViewCell.swift
//  CalorieTracker
//
//  Created by Jessie Ann Griffin on 5/1/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieIntakeTableViewCell: UITableViewCell {

    @IBOutlet private weak var caloriesLabel: UILabel!
    @IBOutlet private weak var dateAndTimeLabel: UILabel!

    var calorieIntake: CalorieIntake? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        guard let calorieIntake = calorieIntake,
            let date = calorieIntake.date,
            let time = calorieIntake.time else { return }
        caloriesLabel.text = "Calories: \(calorieIntake.calories)"
        dateAndTimeLabel.text = "\(date) at \(time)"
    }
}

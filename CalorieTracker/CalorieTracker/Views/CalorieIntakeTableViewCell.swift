//
//  CalorieIntakeTableViewCell.swift
//  CalorieTracker
//
//  Created by Jessie Ann Griffin on 5/1/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import UIKit

class CalorieIntakeTableViewCell: UITableViewCell {

    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!

    var calorieIntake: CalorieIntake? {
        didSet {
            guard let calorieIntake = calorieIntake else { return }
            caloriesLabel.text = "Calories: \(calorieIntake.calories)"
            dateAndTimeLabel.text =
                "\(String(describing: calorieIntake.date)) at \(String(describing: calorieIntake.time))"
        }
    }
}

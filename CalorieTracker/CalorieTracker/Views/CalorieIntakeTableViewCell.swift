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
            guard let calorieIntake = calorieIntake else { return }
            caloriesLabel.text = "Calories: \(calorieIntake.calories)"
            dateAndTimeLabel.text =
                "\(String(describing: calorieIntake.date)) at \(String(describing: calorieIntake.time))"
        }
    }
}

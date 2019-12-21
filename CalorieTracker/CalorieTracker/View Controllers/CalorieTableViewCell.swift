//
//  CalorieTableViewCell.swift
//  CalorieTracker
//
//  Created by brian vilchez on 12/20/19.
//  Copyright © 2019 brian vilchez. All rights reserved.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {

    @IBOutlet weak var calorieIntake: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var calorie: Calorie? {
        didSet{
            updateViews()
        }
    }
    private func updateViews() {
        guard let calorie = calorie else { return }
        calorieIntake.text = String(calorie.intake)
        dateLabel.text = "\(calorie.date)"
    }
}

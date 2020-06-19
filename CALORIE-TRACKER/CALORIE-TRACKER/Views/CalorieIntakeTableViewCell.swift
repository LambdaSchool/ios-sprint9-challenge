//
//  CalorieIntakeTableViewCell.swift
//  CALORIE-TRACKER
//
//  Created by Kelson Hartle on 6/19/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import UIKit

class CalorieIntakeTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var calorieIntakeLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!

    //MARK: - Properties
    var calorieIntake: CalorieIntake? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: - Private functions
    private func updateViews() {
        guard let calorieIntake = calorieIntake else { return }

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "MM/dd/YY, h:mm a"
        let now = dateFormatter.string(from: calorieIntake.timeStamp!)

        calorieIntakeLabel.text = calorieIntake.numOfCalories
        timeStampLabel.text = now
    }
}

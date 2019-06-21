//
//  CalorieTableViewCell.swift
//  Don't Get Fat Tracker
//
//  Created by Michael Redig on 6/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {
	@IBOutlet var caloriesLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!

	private let formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "MM-dd HH:mm"
		return formatter
	}()

	var calories: Calories? {
		didSet {
			updateViews()
		}
	}

	private func updateViews() {
		guard let calories = calories, let timestamp = calories.timestamp else { return }
		caloriesLabel.text = "Calories: \(calories.calories)"
		dateLabel.text = formatter.string(from: timestamp)
	}
}

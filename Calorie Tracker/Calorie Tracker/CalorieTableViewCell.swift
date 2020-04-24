//
//  CalorieTableViewCell.swift
//  Calorie Tracker
//
//  Created by Mark Gerrior on 4/24/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {

    // MARK: - Properties

    var entity: Entity? {
        didSet {
            updateCell()
        }
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()

    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "h:mm a"
        return formatter
    }()

    // MARK: - Outlets

    @IBOutlet private weak var calorieCountLabel: UILabel!
    @IBOutlet private weak var timestampLabel: UILabel!

    // MARK: - Private

    private func updateCell() {
        guard let entity = entity else { return }

        let calorieStr = "Calories: \(entity.calories)"

        let dateString = CalorieTableViewCell.dateFormatter.string(from: entity.timestamp!)
        let timeString = CalorieTableViewCell.timeFormatter.string(from: entity.timestamp!)

        calorieCountLabel.text = "\(calorieStr)"
        timestampLabel.text = "\(dateString) at \(timeString)"
    }
}

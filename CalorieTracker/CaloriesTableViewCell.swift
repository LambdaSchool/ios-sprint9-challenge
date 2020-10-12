//
//  CaloriesTableViewCell.swift
//  CalorieTracker
//
//  Created by Kenneth Jones on 10/12/20.
//

import UIKit

class CaloriesTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var calories: UILabel!
    @IBOutlet private weak var timestamp: UILabel!
    
    var numCalories: Calories? {
        didSet {
            updateViews()
        }
    }
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "MMM dd, yy HH:mm:ss a "
        return formatter
    }

    func updateViews() {
        if let num = numCalories {
            calories.text = "Calories: \(num.intake)"
            timestamp.text = formatter.string(from: num.timestamp ?? Date())
        }
    }

}

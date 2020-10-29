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
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    func updateViews() {
        if let num = numCalories,
           let stamp = num.timestamp {
            let formatted = String(format: "%.0f", num.intake)
            calories.text = "Calories: \(formatted)"
            timestamp.text = formatter.string(from: stamp)
        }
    }

}

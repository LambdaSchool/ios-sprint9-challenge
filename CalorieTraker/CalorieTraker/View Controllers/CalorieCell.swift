//
//  CalorieCell.swift
//  CalorieTraker
//
//  Created by denis cedeno on 5/1/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import UIKit
//protocol ChartsTableViewControllerDelegate {
//    func chartDataChanged(newValueof: Calorie)
//}

class CalorieCell: UITableViewCell {

    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
//    var delegate: ChartsTableViewControllerDelegate!

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()

    var calorie: Calorie? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard let calorie  = calorie else { return }
        calorieLabel.text = "Calories: \(calorie.calories)"
        dateLabel.text = dateFormatter.string(from: calorie.date ?? Date())
//        self.delegate.chartDataChanged(newValueof: calorie)

    }

}

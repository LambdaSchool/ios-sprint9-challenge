//
//  CaloriesTableViewCell.swift
//  CalorieTracker
//
//  Created by Jonalynn Masters on 12/20/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class CaloriesTableViewCell: UITableViewCell {
    @IBOutlet var caloriesLabel: UILabel!
    @IBOutlet var dateAndTimeLabel: UILabel!
    var user: User? {
        didSet {
            updateViews()
        }
    }
    func updateViews() {
        guard let user = user else {return}
         let calories = String(user.calories)
        caloriesLabel.text = calories
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/d/YY, h:mma"
        
        guard let date = user.timestamp else {return}
        dateAndTimeLabel.text = dateFormatter.string(from: date)
    }
}

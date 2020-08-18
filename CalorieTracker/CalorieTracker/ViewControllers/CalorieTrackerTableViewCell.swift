//
//  CalorieTrackerTableViewCell.swift
//  CalorieTracker
//
//  Created by Elizabeth Thomas on 8/14/20.
//  Copyright © 2020 Libby Thomas. All rights reserved.
//

import UIKit

class CalorieTrackerTableViewCell: UITableViewCell {
    
    var calorie: Calorie? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var calorieCountLabel: UILabel!
    @IBOutlet private var timestampLabel: UILabel!
    
    func updateViews() {
        calorieCountLabel?.text = calorie?.calorieCount
        timestampLabel?.text = String(describing: calorie?.timestamp)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

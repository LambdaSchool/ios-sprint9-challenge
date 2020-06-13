//
//  CalorieChartTableViewCell.swift
//  Calorie Tracker
//
//  Created by Juan M Mariscal on 6/12/20.
//  Copyright © 2020 Juan M Mariscal. All rights reserved.
//

import UIKit

class CalorieChartTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

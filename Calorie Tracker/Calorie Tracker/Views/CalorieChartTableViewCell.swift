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
    
    var calorie: Calorie? {
        didSet{
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews() {
        guard let calorie = calorie else { return }
    
        calorieLabel.text = calorie.calorie
        dateLabel.text = calorie.date.toString(dateFormat: "MM/dd/yy, h:mm a")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

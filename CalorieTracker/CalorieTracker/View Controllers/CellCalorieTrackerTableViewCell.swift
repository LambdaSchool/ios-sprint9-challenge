//
//  CellCalorieTrackerTableViewCell.swift
//  CalorieTracker
//
//  Created by Jarren Campos on 6/12/20.
//  Copyright © 2020 Jarren Campos. All rights reserved.
//

import UIKit

class CellCalorieTrackerTableViewCell: UITableViewCell {

    @IBOutlet var calorieCountLabel: UILabel!
    @IBOutlet var calorieDateSavedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

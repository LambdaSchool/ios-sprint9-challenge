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
    
    func setOption(calorie: Calorie){
        calorieCountLabel.text = calorie.calorieAmount
        calorieDateSavedLabel.text = calorie.savedDate
    }

}

//
//  CalorieIntakeTableViewCell.swift
//  calorie-tracker
//
//  Created by De MicheliStefano on 21.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class CalorieIntakeTableViewCell: UITableViewCell {

    var calorieIntake: CalorieIntake? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        
    }

}

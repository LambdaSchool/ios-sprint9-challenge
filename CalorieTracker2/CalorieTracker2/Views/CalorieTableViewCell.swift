//
//  CalorieTableViewCell.swift
//  CalorieTracker2
//
//  Created by Stephanie Ballard on 6/19/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {
    
    var calorieTracker: CalorieTracker?
    //TODO: when you get the dependency injection set up correctly fix the commented out code!
//    var calories: calorie {
//        didSet {
//            updateViews()
//        }
//    }
    
    @IBOutlet weak var caloriesTextLabel: UILabel!
    @IBOutlet weak var timestampTextLabel: UILabel!
    
    func updateViews() {
//        guard let calories =  else { return }
//
//        caloriesTextLabel.text =
//        timestampTextLabel.text =
    }
    
}

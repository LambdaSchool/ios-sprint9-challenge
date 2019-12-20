//
//  CalorieTableViewCell.swift
//  Calorie Tracker
//
//  Created by macbook on 11/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {
    
     var intake: Intake?
    
    // MARK: Outlets
    @IBOutlet weak var caloresLabelView: UILabel!
    @IBOutlet weak var dateLabelView: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
    }
    
    func updateViews() {
        guard let intake = intake else { return }
        
        let caloriesInt = Int(intake.calories)
        caloresLabelView.text = "Calories: \(String(caloriesInt))"
        dateLabelView.text = "Date: \(intake.date)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

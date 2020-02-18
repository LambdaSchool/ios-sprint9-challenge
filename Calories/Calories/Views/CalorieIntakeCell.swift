//
//  CalorieIntakeCell.swift
//  Calories
//
//  Created by Jason Modisett on 1/11/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import UIKit

class CalorieIntakeCell: UITableViewCell {

    private func updateViews() {
        guard let intake = calorieIntake else { return }
        
        nameLabel.text = intake.name
        timeAgoLabel.text = intake.timestamp?.toStringWithRelativeTime()
        countLabel.text = "\(intake.amount)"
    }
    
    
    // MARK:- IBOutlets & properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var calorieIntake: CalorieIntake? { didSet { updateViews() }}
    
}

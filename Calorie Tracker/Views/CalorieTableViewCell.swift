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
    
    //MARK: Outlets
    @IBOutlet weak var caloresLabelView: UILabel!
    @IBOutlet weak var dateLabelView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func updateViews() {
        guard let intake = intake else { return }
        
        let date = TimestampFormatter.formatTimestamp(for: intake)
        
        caloresLabelView.text = "Calories: \(String(intake.calories))"
        dateLabelView.text = date
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

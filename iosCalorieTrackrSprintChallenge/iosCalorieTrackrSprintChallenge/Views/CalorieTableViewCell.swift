//
//  CalorieTableViewCell.swift
//  iosCalorieTrackrSprintChallenge
//
//  Created by BrysonSaclausa on 10/10/20.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {
    
    var calorieIntake: CalorieIntake? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var numberOfCaloriesLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateViews() {
        guard let calorieIntake = calorieIntake?.calories else { return }
        numberOfCaloriesLabel.text = "\(String(calorieIntake)) Calories"
        timeStampLabel.text = String("\(Date())")
    }

}



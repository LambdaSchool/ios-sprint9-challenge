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
    
    
    var dateAdded: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d Y 'at' h:mm a"
        let date = dateformatter.string(from: (calorieIntake?.timestamp)!)
        return date
    }
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var numberOfCaloriesLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    private func updateViews() {
        guard let calorieIntake = calorieIntake?.calories else { return }
        numberOfCaloriesLabel.text = "\(String(calorieIntake)) Calories"
        timeStampLabel.text = String("\(dateAdded)")
    }

}



//
//  CalorieIntakeTableViewCell.swift
//  CalorieTracker
//
//  Created by Michael on 2/28/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import UIKit

class CalorieIntakeTableViewCell: UITableViewCell {

    var intake: CalorieIntake? {
        didSet {
            updateViews()
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter
    }()
    
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func updateViews() {
        guard let intake = intake else { return }
        calorieLabel.text = "Calories: \(intake.calories)"
        dateLabel.text = dateFormatter.string(from: intake.date ?? Date())
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

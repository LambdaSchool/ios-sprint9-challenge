//
//  CaloriesTableViewCell.swift
//  CalorieTracker
//
//  Created by Luqmaan Khan on 9/20/19.
//  Copyright © 2019 Luqmaan Khan. All rights reserved.
//

import UIKit

class CaloriesTableViewCell: UITableViewCell {
    @IBOutlet var caloriesLabel: UILabel!
    @IBOutlet var dateAndTimeLabel: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        caloriesLabel.text = user?.calories
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-d, h:mm-a"
        guard let date = user?.timestamp else {return}
        dateAndTimeLabel.text = dateFormatter.string(from: date)
    }
    
    
}

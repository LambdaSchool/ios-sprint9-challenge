//
//  MealTableViewCell.swift
//  CalorieTracker
//
//  Created by Jonathan Ferrer on 6/28/19.
//  Copyright © 2019 Jonathan Ferrer. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!

}

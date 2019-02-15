//
//  CalorieEntryTableViewCell.swift
//  CalorieTrackerDaily
//
//  Created by TuneUp Shop  on 2/15/19.
//  Copyright © 2019 jkaunert. All rights reserved.
//

import UIKit
import CoreData

class CalorieEntryTableViewCell: UITableViewCell {

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

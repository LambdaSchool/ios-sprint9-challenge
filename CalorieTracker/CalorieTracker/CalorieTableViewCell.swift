//
//  CalorieTableViewCell.swift
//  CalorieTracker
//
//  Created by John McCants on 2/11/21.
//  Copyright © 2021 John McCants. All rights reserved.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {

    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews() {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  CaloriesTableViewCell.swift
//  CalorieTraker
//
//  Created by Jocelyn Stuart on 3/15/19.
//  Copyright © 2019 JS. All rights reserved.
//

import UIKit

class CaloriesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    

}

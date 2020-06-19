//
//  CalorieCell.swift
//  CalorieTracker
//
//  Created by Nonye on 6/19/20.
//  Copyright © 2020 Nonye Ezekwo. All rights reserved.
//

import UIKit

class CalorieCell: UITableViewCell {
    
    // MARK: - OUTLETS

    @IBOutlet weak var calorieCountLabel: UILabel!
    
    @IBOutlet weak var calorieDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

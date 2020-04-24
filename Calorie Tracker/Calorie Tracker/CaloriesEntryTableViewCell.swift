//
//  CaloriesEntryTableViewCell.swift
//  Calorie Tracker
//
//  Created by Karen Rodriguez on 4/24/20.
//  Copyright © 2020 Hector Ledesma. All rights reserved.
//

import UIKit

class CaloriesEntryTableViewCell: UITableViewCell {
    // MARK: - Outlet
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  CalorieTrackerTableViewCell.swift
//  CalorieTracker
//
//  Created by Ciara Beitel on 10/18/19.
//  Copyright © 2019 Ciara Beitel. All rights reserved.
//

import UIKit

class CalorieTrackerTableViewCell: UITableViewCell {
    // MARK: - Outlets

    @IBOutlet weak var intakeLabel: UILabel!
    @IBOutlet
    weak var timestampLabel: UILabel!
    // MARK: - Functions

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

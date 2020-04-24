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

    // MARK: - Property

    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    var formatter: DateFormatter?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func updateViews() {
        guard let entry = entry,
        let formatter = formatter,
            let date = entry.date else { return }
        caloriesLabel.text = "Calories: \(entry.calories)"
        dateLabel.text = formatter.string(from: date)
    }

}

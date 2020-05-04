//
//  TrackerTableViewCell.swift
//  Calorie_Tracker
//
//  Created by Joe on 5/3/20.
//  Copyright © 2020 AlphaGradeINC. All rights reserved.
//

import UIKit

class TrackerTableViewCell: UITableViewCell {

 
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let entryController = EntryController()
        var entry: Entry? {
            didSet {
                updateViews()
            }
        }
        
        func updateViews() {
            guard let entry = entry else { return }
            DispatchQueue.main.async {
                self.calorieLabel.text = "\(entry.calories)"
                self.dateLabel.text = ""
            }
        }
    }


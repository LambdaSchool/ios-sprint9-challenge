//
//  CalorieLogTableViewCell.swift
//  CalorieTracker
//
//  Created by Zachary Thacker on 10/12/20.
//

import UIKit

class CalorieLogTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let reuseIdentifier = "calorieLogCell"
        
    var entry: CalorieLog? {
        didSet {
            updateViews()
        }
    }
    //MARK: - IBOutlets
    
    @IBOutlet weak var calorieNumberLabel: UILabel!
    @IBOutlet weak var calorieLogDateLabel: UILabel!
    

    
    //MARK: - Actions
   
    private func updateViews() {
        guard let calorieLog = entry else { return }
        calorieNumberLabel.text = entry?.calories
        calorieLogDateLabel.text = TimeStampFormatter.formatdate(for: entry)
        
    }
}



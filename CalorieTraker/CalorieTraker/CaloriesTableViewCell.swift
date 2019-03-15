//
//  CaloriesTableViewCell.swift
//  CalorieTraker
//
//  Created by Jocelyn Stuart on 3/15/19.
//  Copyright © 2019 JS. All rights reserved.
//

import UIKit

extension Date {
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}

class CaloriesTableViewCell: UITableViewCell {

    var calorie: Calorie? {
        didSet {
            updateViews()
        }
    }
    
    private func updateViews() {
        guard let calorie = calorie,
            let timestamp = calorie.timestamp else { return }
        
        caloriesLabel.text = "Calories: \(Int(calorie.amount))"
        dateLabel.text = timestamp.dateString()
        
    }
    
    
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    

}

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
    
    var calorieLog: CalorieLog? {
        didSet {
            updateViews()
        }
    }
    //MARK: - IBOutlets
    
    @IBOutlet weak var calorieNumberLabel: UILabel!
    @IBOutlet weak var calorieLogDateLabel: UILabel!
    
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy, HH:mm"
        return dateFormatter
    }()
    
    //MARK: - Actions
   
    private func updateViews() {
        guard let calorieLog = calorieLog else { return }
        calorieNumberLabel.text = "Calpries: \(calorieLog.calories)"
        calorieLogDateLabel.text = self.dateFormatter.string(from: calorieLog.date!)
        
        
        
        
    }
}

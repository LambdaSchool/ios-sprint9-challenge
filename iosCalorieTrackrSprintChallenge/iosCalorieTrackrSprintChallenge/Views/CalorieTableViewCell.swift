//
//  CalorieTableViewCell.swift
//  iosCalorieTrackrSprintChallenge
//
//  Created by BrysonSaclausa on 10/10/20.
//

import UIKit

class CalorieTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var calorieIntake: CalorieIntake? {
        didSet {
            createObserver()
            updateViews()
        }
    }
    
    
    var dateAdded: String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM d Y 'at' h:mm a"
        let date = dateformatter.string(from: (calorieIntake?.timestamp)!)
        return date
    }
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var numberOfCaloriesLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    // MARK: - Functions
    
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews(notification:)), name: .doneWasTapped, object: nil)
        print("OBSERVING")
    }
   
    @objc func refreshViews(notification: Notification) {
       updateViews()
    }
    
    func updateViews() {
        guard let calorieIntake = calorieIntake?.calories else { return }
        numberOfCaloriesLabel.text = "Calories: \(String(calorieIntake))"
        timeStampLabel.text = String("\(dateAdded)")
    }
    
    

}



//
//  Alerts.swift
//  Calorie Tracker
//
//  Created by Chris Gonzales on 3/27/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import UIKit

struct Alerts {
    
    func callAddEntry() -> String? {
        let alert = UIAlertController(title: "Add Calorie Intake",
                                      message: "Enter the amount of calories in the field.", preferredStyle: .actionSheet)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Input caloric intake here"
        }
        let textFields = alert.textFields
        let alertTextField = textFields![0]
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Submit", style: .default))
        
        alert.present(alert, animated: true)
        
        guard let inputCalories = alertTextField.text else { return nil }
        
        return inputCalories
    }
}

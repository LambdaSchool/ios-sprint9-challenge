//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Shawn Gee on 4/24/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit
import CoreData

extension NSNotification.Name {
    static let calorieEntryAdded = NSNotification.Name("CalorieEntryAdded")
}

class CalorieTrackerViewController: UIViewController {
    
    // MARK: - IBActions
    
    @IBAction func addCalorieIntake(_ sender: Any) {
        let ac = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        var calorieTextField: UITextField?
        
        ac.addTextField { textField in
            textField.keyboardType = .numberPad
            calorieTextField = textField
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("Cancel")
            return
        }))
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
            guard let text = calorieTextField?.text, let calories = Int(text) else {
                print("Invalid calorie entry")
                return
            }
            print("Submit tapped with \(calories) calories")
            CalorieEntry(calories: calories)
            
            do {
                try CoreDataStack.shared.save()
                NotificationCenter.default.post(name: .calorieEntryAdded, object: nil)
            } catch {
                print(error)
            }
        }))
        
        present(ac, animated: true)

    }
}

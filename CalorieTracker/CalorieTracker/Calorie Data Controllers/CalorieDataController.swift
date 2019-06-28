//
//  CalorieDataController.swift
//  CalorieTracker
//
//  Created by Sameera Roussi on 6/28/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//



import UIKit
import CoreData

class CalorieDataController {
    
    var caloriePoint: Int16 = 0
    
//    // Create calorie input box
//    func createInputDialog() {
//        let inputDialog = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
//        
//        // Placeholder text
//        inputDialog.addTextField { (caloriesInput) in caloriesInput.placeholder = "Calories"}
//        
//        // Dialog submit action
//        let submitAction = UIAlertAction(title: "Submit", style: .default) { ( _ ) in
//            // Make sure there is a text field
//            if let caloriesInputField = inputDialog.textFields?[0] {
//                let fieldText = caloriesInputField.text
//                let caloriePoint = Int16(fieldText ?? "0")
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
//        
//        inputDialog.addAction(submitAction)
//        inputDialog.addAction(cancelAction)
//        
//        // Present the dialog box
//        present(inputDialog, animated: true, completion: nil)
//    }
        
    
    func see() {
        let alertController = UIAlertController(title: "Email?", message: "Please input your email:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            guard let textFields = alertController.textFields,
                textFields.count > 0 else {
                    // Could not find textfield
                    return
            }
            
            let field = textFields[0]
            // store your data
            UserDefaults.standard.set(field.text, forKey: "userEmail")
            UserDefaults.standard.synchronize()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        
    }
    
    
    
    
    func getNewDataPoints() {
        
        
    }
    
}




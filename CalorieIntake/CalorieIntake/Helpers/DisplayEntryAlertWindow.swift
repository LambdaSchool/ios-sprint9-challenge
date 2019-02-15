//
//  DisplayEntryAlertWindow.swift
//  CalorieIntake
//
//  Created by Benjamin Hakes on 2/15/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import UIKit


class DisplayEntryAlertWindow {
    
    static func getAlterDisplay() -> UIAlertController {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in
            
            guard let text = alert.textFields?[0].text, !text.isEmpty else {
                return
            }
            
            switch action.style{
            case .default:
                guard let count = Double(text) else { return }
                _ = CalorieEvent(numberOfCalories: count)
                do {
                    try CoreDataStack.shared.mainContext.save()
                } catch {
                    print("unable to save new calorie event to Core Data")
                    return
                }
                return
            case .cancel:
                return
            case .destructive:
                return
            }}))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            return
        }))
        
        return alert
    }
    
}

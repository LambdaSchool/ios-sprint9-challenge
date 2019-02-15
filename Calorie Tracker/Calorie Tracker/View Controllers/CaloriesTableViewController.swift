
import Foundation
import SwiftChart

class CaloriesTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        
        showInputPopUp()
        
    }
    
    func showInputPopUp() {
        
        // Create UIAlertController, set title and message
        let alertController = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field below", preferredStyle: .alert)
        
        // Confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            
            // Get the input values from user
            let calories = alertController.textFields?[0].text
            
            // Put the user-entered amount into the caloriesInput property
            // caloriesInput = calories(calories: calories, timestamp: Date())
        }
        
        // Cancel action does nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        // Add textfield to popup
        alertController.addTextField { (textField) in
            textField.placeholder = "Calories:"
        }
        
        // Add action to popup
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // Present the popup
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

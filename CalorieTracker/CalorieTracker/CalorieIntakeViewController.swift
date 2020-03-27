//
//  CalorieIntakeViewController.swift
//
//
//  Created by Lambda_School_Loaner_268 on 3/27/20.
//

import UIKit
import SwiftChart
class CalorieIntakeViewController: UIViewController {
    
    @IBOutlet weak var calorieChart: Chart!
     
     @IBOutlet weak var calorieTable: UITableView!
    
    // MARK: - Data Source
    
  

    var dataDict = [Int: Date]()
    var keyArray: [Int] = []
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = "Calories"

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addColorieSource(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Calorie Amount", message: "Enter the amount of calories in the text field! ", preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self] action in
            guard let textField = alertController.textFields?.first, let amountToSave = Int(textField.text!) else {
                    return
            }
            self.dataDict[amountToSave] = Date()
            self.keyArray.append(amountToSave)
            self.calorieTable.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addTextField()
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        }
}


extension CalorieIntakeViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return keyArray.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath)
                 -> UITableViewCell {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell",
                                    for: indexPath)
                    
                    cell.textLabel?.text = String(keyArray[indexPath.row])
    return cell
  }
}

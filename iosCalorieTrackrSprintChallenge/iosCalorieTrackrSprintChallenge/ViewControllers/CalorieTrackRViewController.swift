//
//  CalorieTrackRViewController.swift
//  iosCalorieTrackrSprintChallenge
//
//  Created by BrysonSaclausa on 10/10/20.
//

import UIKit
import CoreData
import SwiftChart


class CalorieTrackRViewController: UIViewController {
    
    //MARK: - IBoutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: Chart!
    
   
    
    //MARK: - Properties
    var calorieIntakeArray: [CalorieIntake] {
        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("error")
            return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
//    MARK: - Functions

    @IBAction func addTapped(_ sender: Any) {
        showTextViewAlert()
    }
     
    @objc func showTextViewAlert() {
        let alertView = UIAlertController(title: "Add Calorie Intake", message: "Enter The Amount Of Calories In The Field", preferredStyle: .alert)
        
        alertView.addTextField(configurationHandler: nil)
        alertView.textFields![0].placeholder = "Calories"
        
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            //TODO
            guard let calorieInput = Double(alertView.textFields![0].text!), !calorieInput.isZero else { return }
            let date = Date()
            print(date)
            print("DONE WAS TAPPED! ENTERED \(calorieInput) CALORIES AT \(Date())")
            CalorieIntake(calories: Double(calorieInput), timestamp: date)
            self.tableView.reloadData()
            self.updateChart()
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                print("error try to save")
            }
    }  ))
        let textfield = alertView.textFields![0] as UITextField
        textfield.keyboardType = UIKeyboardType.numberPad
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    
    @objc func updateChart() {
        let calorieChart = Chart(frame: chartView.frame)
        
        
            
        
           }
    
}





// MARK: - TableView Delegate + DataSource

extension CalorieTrackRViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calorieIntakeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CalorieTableViewCell else { fatalError() }
        cell.calorieIntake = calorieIntakeArray[indexPath.row]
        return cell
    }
}



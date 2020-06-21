//
//  CalorieTrackerViewController.swift
//  CalorieTracker2
//
//  Created by Stephanie Ballard on 6/19/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation
import CoreData
import SwiftChart

/*

Put in a bar button item with system type 'add' and give it an IBAction
write in methods that will grab data via a UI alert and add it to core data
write in methods that add the data from core data to the views and update it when the user submits (use the notification center)
*/

class CalorieTrackerViewController: UIViewController {
    
    var calorieTracker = CalorieTracker()
    var coreDataStack: CoreDataStack?
    
    @IBOutlet weak var chartView: Chart!
    @IBOutlet weak var caloriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let series = ChartSeries([1, 6, 2, 8, 4, 7, 3, 10, 8])
        series.color = ChartColors.greenColor()
        chartView.add(series)
        
        caloriesTableView.dataSource = self
        caloriesTableView.delegate = self
        
    }
    
    @IBAction func addCaloriesButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        let submitCaloriesAction = UIAlertAction(title: "Submit", style: .default) {
            [unowned self] action in
            guard let textField = alert.textFields?.first,
                let caloriesToSubmit = textField.text else {
                    return
            }
            do {
                try self.coreDataStack?.save()
                self.caloriesTableView.reloadData()
            } catch {
                print("Error saving calories: \(error)")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(submitCaloriesAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
}

extension CalorieTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension CalorieTrackerViewController: UITableViewDelegate {
    
}

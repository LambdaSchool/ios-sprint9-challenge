//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Kenneth Jones on 10/9/20.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {
    
    @IBOutlet private weak var dataChart: Chart!
    @IBOutlet private weak var dataTable: CaloriesTableView!
    
    var caloriesController = CaloriesController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .showNewData, object: nil)
        dataTable.caloriesController = caloriesController
        updateViews()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        alert.addTextField { (alertText) in
            alertText.text = "Calories:"
        }
    }
    
    @IBAction func dataChanged(_ sender: Chart) {
        
    }
    
    @objc func updateViews() {
        let chart = Chart(frame: dataChart.frame)
        dataTable.reloadData()
    }
    
}

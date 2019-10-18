//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Lambda_School_Loaner_214 on 10/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {

    // MARK: - Private properties
    private var calorieDataController = CalorieDataController()
    private lazy var series: ChartSeries = {
        ChartSeries(calorieDataController.calorieData.compactMap { Double($0.calories) })
    }()
    
    // MARK: - IBOutlets
    @IBOutlet private weak var chartView: Chart!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        chartView.add(series)
        self.observeDataChanged()
    }
    
    func observeDataChanged() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews(notification:)), name: .dataWasAdded, object: nil)
    }
    @objc func refreshViews (notification: Notification) {
        tableView.reloadData()
        chartView.removeAllSeries()
        chartView.add(self.series)
    }
    
    // MARK: - IBActions
    @IBAction func addtapped(_ sender: Any) {
     let alert = UIAlertController(title: "New Calories", message: "Enter calorie count", preferredStyle: .alert)
           alert.addTextField { textField in
               textField.text = ""
           }
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
               if let textField = alert?.textFields?[0] {
                if let textValue = Int(textField.text ?? "") {
                    self.calorieDataController.addCount(textValue)
                   }
               }
           }))
           alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
           self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calorieDataController.calorieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        cell.textLabel?.text = "Calories: \( calorieDataController.calorieData[indexPath.row].calories)"
        cell.detailTextLabel?.text = calorieDataController.calorieData[indexPath.row].datetimestamp?.formatted()
        return cell
    }
}

//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Cameron Dunn on 3/15/19.
//  Copyright © 2019 Cameron Dunn. All rights reserved.
//

import UIKit
import SwiftChart
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChartDelegate {
    
    
    var model : Model?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calorieChart: Chart!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = Model()
        calorieChart.delegate = self
        reloadViews()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.calorieLogs.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! CustomTableViewCell
        cell.caloriesLabel.text = "Calories: \(model!.calorieLogs[indexPath.row].value(forKey: "calories") ?? "0")"
        cell.dateLabel.text = "\(model?.calorieLogs[indexPath.row].value(forKey: "date") ?? Date())"
        return cell
    }
    
    
    @IBAction func addPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Intake", message: "Add the amount of calories in the field", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields![0].keyboardType = .numberPad
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: .default){_ in
            //Add new calorie log here.
            guard let safeDouble : Double = Double(alert.textFields![0].text!) else {return}
            CalorieLogStore(calories: safeDouble, date: Date())
            self.model?.saveToPersistentStore()
            self.reloadViews()
        })
        self.present(alert, animated: true)
    }
    func reloadViews(){
        var doubleArray : [Double] = []
        self.model?.loadFromPersistentStore()
        for log in (self.model?.calorieLogs)!{
            doubleArray.append(log.value(forKey: "calories") as! Double)
        }
        let series = ChartSeries(doubleArray)
        self.calorieChart.add(series)
        self.tableView.reloadData()
    }

}


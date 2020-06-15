//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Matthew Martindale on 6/14/20.
//  Copyright © 2020 Matthew Martindale. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {

    @IBOutlet weak var chartView: Chart!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showChart()
    }

    func showChart() {
        let data = [
          (x: 0, y: 0),
          (x: 1, y: 3.1),
          (x: 4, y: 2),
          (x: 5, y: 4.2),
          (x: 7, y: 5),
          (x: 9, y: 9),
          (x: 10, y: 8)
        ]
        let series = ChartSeries(data: data)
        chartView.add(series)
    }
    
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? CalorieTableViewCell else {
            return UITableViewCell()
        }
        
        
        return cell
    }
    
    
}


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
your model, forgive the softball is;
Entity: EntityName
    caloriesPropertyName: Double
    datePropertyName: Date

thassit. you can do the whole app with two numbers.

so you make a core data model
write a core data stack with a shared instance(singleton)
write a convenience init (protip. use the current date as the default value and you only need one property to init)
Make a view controller for your project w/ a view that inherits from chart and a tableview that uses a right detail layout, write in outlets for both
Put in a bar button item with system type 'add' and give it an IBAction
extend to conform to tableview datasource and set the datasource
write in methods that will grab data via a UI alert and add it to core data
write in methods that add the data from core data to the views and update it when the user submits (use the notification center)
*/

class CalorieTrackerViewController: UIViewController {
    
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

//
//  CaloriesTableViewController.swift
//  calorie-tracker
//
//  Created by Hector Steven on 6/28/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit
import SwiftChart

class CaloriesTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
		chart.delegate = self
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieTableViewCell", for: indexPath) as?
			CalorieTableViewCell else { return UITableViewCell()}
		
		cell.calorieLabel?.text = "\(indexPath.row)"
		return cell
	}
	
	@IBOutlet var chart: Chart!
}

extension CaloriesTableViewController: ChartDelegate {
	func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
		
	}
	
	func didFinishTouchingChart(_ chart: Chart) {
		
	}
	
	func didEndTouchingChart(_ chart: Chart) {
		
	}
	
	
}

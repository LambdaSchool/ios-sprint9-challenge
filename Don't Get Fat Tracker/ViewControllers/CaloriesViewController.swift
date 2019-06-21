//
//  CaloriesViewController.swift
//  Don't Get Fat Tracker
//
//  Created by Michael Redig on 6/21/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import UIKit
import SwiftChart

class CaloriesViewController: UIViewController {
	@IBOutlet var chartParentView: UIView!
	let chart = Chart()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupChart()
	}

	func setupChart() {
		chartParentView.addSubview(chart)

		chart.minY = 0
		chart.translatesAutoresizingMaskIntoConstraints = false
		chart.topAnchor.constraint(equalTo: chartParentView.topAnchor).isActive = true
		chart.bottomAnchor.constraint(equalTo: chartParentView.bottomAnchor).isActive = true
		chart.leadingAnchor.constraint(equalTo: chartParentView.leadingAnchor).isActive = true
		chart.trailingAnchor.constraint(equalTo: chartParentView.trailingAnchor).isActive = true
	}

	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		let alert = UIAlertController(title: "Add Calorie Intake", message: "Careful what you eat!", preferredStyle: .alert)
		var calorieTextField: UITextField?
		alert.addTextField { (textField) in
			calorieTextField = textField
			calorieTextField?.addTarget(self, action: #selector(self.calorieTextFieldEdited), for: .editingChanged)
		}
		let action = UIAlertAction(title: "Add", style: .default) { [weak self] (action) in
			guard let calorieString = calorieTextField?.text, let calorieAmount = Double(calorieString) else { return }
			if let series = self?.chart.series.first {
				series.data.append((x: Double(series.data.count), y: calorieAmount))
				self?.chart.add(series)
		} else {
				let series = ChartSeries([calorieAmount])
				self?.chart.add(series)
			}
		}
		let cancel = UIAlertAction(title: "Cancel", style: .cancel)
		alert.addAction(action)
		alert.addAction(cancel)
		present(alert, animated: true)
	}

	@IBAction func calorieTextFieldEdited(_ sender: UITextField) {
		sender.text = sender.text?.replacingOccurrences(of: ##"\D"##, with: "", options: .regularExpression, range: nil)
	}
}

extension CaloriesViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
	}


}

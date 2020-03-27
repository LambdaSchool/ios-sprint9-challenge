//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by scott harris on 3/27/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit

class CalorieTrackerViewController: UIViewController {
    
    let calorieEntryController = CalorieEntryController()
    let tableView = UITableView()
    let chartView = CalorieChartView()
    
    lazy var dateFormatter: DateFormatter = {
       let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupChartView()
        setupTableView()
        tableView.register(CalorieEntryCell.self, forCellReuseIdentifier: "EntryCell")
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .didRecieveNewCalorieEntries, object: nil)
        updateViews()
    }
    
    @objc private func updateViews() {
        tableView.reloadData()
        reloadChart()
    }
    
    private func reloadChart() {
        let data = calorieEntryController.calorieEntries.map { $0.calories }
        chartView.setSeries(values: data)
    }
    
    private func setupNavigationBar() {
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCaloriesTapped))
        rightBarButton.tintColor = .label
        navigationItem.rightBarButtonItem = rightBarButton
        title = "Calorie Tracker"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: chartView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func setupChartView() {
        view.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        chartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        chartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: view.bounds.height / 3).isActive = true
 
    }
    
    @objc private func addCaloriesTapped() {
        let ac = UIAlertController(title: "Add Calorie Intake", message: "Enter the amount of calories in the field.", preferredStyle: .alert)
        ac.addTextField()
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitButton = UIAlertAction(title: "Submit", style: .default) { (action) in
          // DEAL With in a little bit...
            guard let textFields = ac.textFields, let text = textFields[0].text else { return }
            if let calsAsDouble = Double(text) {
                self.calorieEntryController.createCalorieEntry(calories: calsAsDouble)
            }
            
        }
        ac.addAction(cancelButton)
        ac.addAction(submitButton)
        present(ac, animated: true)
        
    }
}

extension CalorieTrackerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calorieEntryController.calorieEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as? CalorieEntryCell else { return UITableViewCell() }
        
        let entry = calorieEntryController.calorieEntries[indexPath.row]
        
        cell.caloriesLabel.text = "Calories: \(Int(entry.calories))"
        if let date = entry.date {
            cell.dateLabel.text = dateFormatter.string(from: date)
        }

        return cell
    }
}


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
    
    // MARK: - IBoutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var chartView: Chart!
    
    // MARK: - Properties
    
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
    
    // MARK: - Chart Implementation
    var caloriesAdded: CalorieIntake?
    var calories: [CalorieIntake] = []
    var chartNumbers: [Double] = []
    
    func setupChart() {
        chartView.axesColor = .systemTeal
        chartView.gridColor = .systemRed
        chartView.backgroundColor = .systemBackground
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        setupChart()
        //createObserver()
        refreshViews()
        
        
    }
    
    // MARK: - Observer
//    func createObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshViews()), name: .doneWasTapped, object: nil)
//        print("OBSERVING")
//    }
   
    @objc func refreshViews() {
        let calorieCollection = calorieIntakeArray
        let seriesArray = calorieCollection.map { $0.calories }
        let series = ChartSeries(seriesArray)
        chartView.add(series)
        tableView.reloadData()
    }
    
    // MARK: - Functions
    
    @IBAction func addTapped(_ sender: Any) {
        showTextViewAlert()
    }
    
    @objc func showTextViewAlert() {
        let alertView = UIAlertController(title: "Add Calorie Intake", message: "Enter The Amount Of Calories In The Field", preferredStyle: .alert)
        
        alertView.addTextField(configurationHandler: nil)
        alertView.textFields![0].placeholder = "Calories"
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            
            NotificationCenter.default.post(name: .doneWasTapped, object: nil)
            
            guard let calorieInput = Double(alertView.textFields![0].text!), !calorieInput.isZero else { return }
            let date = Date()
            print("DONE WAS TAPPED! ENTERED \(calorieInput) CALORIES AT \(Date())")
            
            let calorie = CalorieIntake(calories: Double(calorieInput), timestamp: date)
            self.tableView.reloadData()
            let calorieNumber = calorie.calories
            self.chartNumbers.append(calorieNumber)
            let series = ChartSeries(self.chartNumbers)
            self.chartView.add(series)
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                print("error try to save")
            }
        }
        ))
        let textfield = alertView.textFields![0] as UITextField
        textfield.keyboardType = UIKeyboardType.numberPad
        
        self.present(alertView, animated: true, completion: nil)
    }
}

// MARK: - TableView Delegate + DataSource

extension CalorieTrackRViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        calorieIntakeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CalorieTableViewCell else { fatalError("error") }
        cell.calorieIntake = calorieIntakeArray[indexPath.row]
        return cell
    }
}

//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by David Wright on 5/3/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerViewController: UIViewController {
    
    lazy var fetchedResultsController: NSFetchedResultsController<CalorieDataPoint> = {
        let fetchRequest: NSFetchRequest<CalorieDataPoint> = CalorieDataPoint.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "userName", ascending: true),
                                        NSSortDescriptor(key: "timestamp", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "userName",
                                             cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching results: \(error)")
        }
        return frc
    }()
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy, h:mm:ss a"
        return dateFormatter
    }()
    
    @IBOutlet private weak var calorieChart: Chart!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateViews),
                                               name: .calorieDataPointAddedNotificationName,
                                               object: nil)
        
        updateViews()
    }
    
    @IBAction func addCaloriesButtonTapped(_ sender: UIBarButtonItem) {
        showCalorieIntakeAlert()
    }
    
    @objc private func updateViews() {
        tableView.reloadData()
        updateChart()
    }
    
    private func updateChart() {
        var userNames = [String]()
        var allSeries = [ChartSeries]()
        let sections = fetchedResultsController.sections ?? []
        
        for section in sections {
            userNames.append(section.name)
            guard let calorieDataPoints = section.objects as? [CalorieDataPoint] else { continue }
            let caloriesData = calorieDataPoints.compactMap { $0.calories }
            let series = ChartSeries(caloriesData)
            series.area = true
            series.color = ChartColors.colorForIndex(allSeries.count + 1)
            allSeries.append(series)
        }
        
        calorieChart.add(allSeries)
    }
    
    private func addCalories(_ calories: Double, forUser userName: String) {
        CalorieDataPoint(calories: calories, userName: userName)
        do {
            try CoreDataStack.shared.save()
        } catch {
            print("Error saving task to database: \(error)")
        }
        NotificationCenter.default.post(Notification(name: .calorieDataPointAddedNotificationName, object: nil))
    }
    
    private func showCalorieIntakeAlert() {
        let alert = UIAlertController(title: "Add Calorie Intake",
                                      message: "Enter your name and the amount of calories to add",
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Name:"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Calories:"
            textField.keyboardType = .numberPad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            guard let textFields = alert.textFields,
                let userName = textFields[0].text,
                !userName.isEmpty,
                let caloriesString = textFields[1].text,
                !caloriesString.isEmpty,
                let calories = Double(caloriesString) else { return }
            
            self.addCalories(calories, forUser: userName)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension CalorieTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections?[section]
        return sectionInfo?.name.capitalized
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieDataPointCell", for: indexPath)
        let calorieDataPoint = fetchedResultsController.object(at: indexPath)
        let userName = calorieDataPoint.userName ?? "Unknown User"
        let calories = calorieDataPoint.calories
        let timestamp = calorieDataPoint.timestamp ?? Date()
        
        cell.textLabel?.text = "\(userName)'s calories: \(Int(calories))"
        cell.detailTextLabel?.text = dateFormatter.string(from: timestamp)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let calorieDataPoint = fetchedResultsController.object(at: indexPath)
            let context = CoreDataStack.shared.mainContext
            do {
                context.delete(calorieDataPoint)
                try CoreDataStack.shared.save()
                NotificationCenter.default.post(Notification(name: .calorieDataPointAddedNotificationName, object: nil))
            } catch {
                context.reset()
                print("Error deleting object from managed object context: \(error)")
            }
        }
    }
}

// MARK: - FRC Delegate

extension CalorieTrackerViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath,
            let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

extension NSNotification.Name {
    static let calorieDataPointAddedNotificationName = NSNotification.Name("calorieDataPointAddedNotificationKey")
}

extension ChartColors {
    public static func colorForIndex(_ index: Int) -> UIColor {
        switch index % 13 {
        case 1:
            return ChartColors.blueColor()
        case 2:
            return ChartColors.greenColor()
        case 3:
            return ChartColors.redColor()
        case 4:
            return ChartColors.yellowColor()
        case 5:
            return ChartColors.purpleColor()
        case 6:
            return ChartColors.cyanColor()
        case 7:
            return ChartColors.darkGreenColor()
        case 8:
            return ChartColors.darkRedColor()
        case 9:
            return ChartColors.goldColor()
        case 10:
            return ChartColors.maroonColor()
        case 11:
            return ChartColors.orangeColor()
        case 12:
            return ChartColors.pinkColor()
        default:
            return ChartColors.greyColor()
        }
    }
}

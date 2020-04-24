//
//  CalorieTrackerViewController.swift
//  Cal_Tracker
//
//  Created by Lydia Zhang on 4/24/20.
//  Copyright © 2020 Lydia Zhang. All rights reserved.
//

import UIKit
import SwiftChart
import CoreData

class CalorieTrackerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var calorieController = CalorieController()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Calorie> = {
        let fetchRequest: NSFetchRequest<Calorie> = Calorie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        return frc
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = calorieTV.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        let calorie = fetchedResultsController.object(at: indexPath)
        
        cell.textLabel?.text = "Calorie: \(calorie.calorie)"
        cell.detailTextLabel?.text = dateFormatter.string(from: calorie.time ?? Date())
        return cell
    }
    
    @IBOutlet weak var chart: UIView!
    
    
    @IBOutlet weak var calorieTV: UITableView!
    @IBAction func addCalorie(_ sender: Any) {
        let alert = UIAlertController(title: "Add Calorie Taken", message: "Enter Calories Intake Below", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter"
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default) { _ in
            guard let calories = alert.textFields?.first?.text, !calories.isEmpty, let calorieInt = Int(calories) else {return}
            self.calorieController.create(calorie: Int16(calorieInt))
            NotificationCenter.default.post(name: NSNotification.Name("Calorie"), object: self)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calorieTV.dataSource = self
        calorieTV.delegate = self
        update()
        
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("Calorie"), object: nil)
    }
    let chartView = Chart()
    //do not put this inside update! will make new chart everytime!
    @objc func update() {
        var scale: [Double] = [] //keep this inside function so it doesnt presist outside!
        chartView.frame = CGRect(x: 20, y: 20, width: chart.bounds.maxX - 40, height: chart.bounds.maxY - 40)
        guard let datas = fetchedResultsController.fetchedObjects else {return}
        for data in datas {
            scale.append(Double(data.calorie))
        }
        chartView.isUserInteractionEnabled = true
        chart.addSubview(chartView)
        let series = ChartSeries(scale)
        series.area = true
        series.color = ChartColors.pinkColor()
        if chartView.series.isEmpty == false {
            chartView.removeAllSeries()
        }
        chartView.add(series)
        calorieTV.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calorieTV.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        calorieTV.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            calorieTV.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            calorieTV.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
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
            calorieTV.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            calorieTV.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            calorieTV.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let fromIndexPath = indexPath, let toIndexPath = newIndexPath else { return }
            calorieTV.deleteRows(at: [fromIndexPath], with: .automatic)
            calorieTV.insertRows(at: [toIndexPath], with: .automatic)
        @unknown default:
            break
        }
    }
}

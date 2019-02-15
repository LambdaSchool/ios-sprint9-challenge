//
//  CalorieTrackerTableViewController.swift
//  Calorie Tracker
//
//  Created by Ivan Caldwell on 2/15/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

extension Notification.Name{
    static let entriesDidChange = Notification.Name("entriesDidChange")
}

import UIKit
import CoreData
import SwiftChart

class CalorieTrackerTableViewController: UITableViewController{
    var entries: [CalorieEntry] = []
    
    // MARK: - Properties
    var calories: [CalorieEntry] = []
    let calorieTrackerController = CalorieTrackerController()

    
    var dateFormatter: DateFormatter  {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entries = fetchCalorieEntryFromStore()
        // Don't think I will need this here...
        NotificationCenter.default.addObserver(self, selector: #selector(entriesDidChange(_:)), name: .entriesDidChange, object: nil)
        tableView.reloadData()
    }
    
    func viewWillAppear() {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(entriesDidChange(_:)), name: .entriesDidChange, object: nil)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath)
        cell.textLabel?.text = "Calories: \(entries[indexPath.row].calorie) \t\t\t\((entries[indexPath.row].timestamp)!)"
        return cell
    }
    
    func fetchCalorieEntryFromStore() -> [CalorieEntry] {
        let fetchRequest: NSFetchRequest<CalorieEntry> = CalorieEntry.fetchRequest()
        let result = (try? CoreDataStack.shared.mainContext.fetch(fetchRequest)) ?? []
        return result
    }
    
    @objc func entriesDidChange(_ notification: Notification) {
        tableView?.reloadData()
    }
}

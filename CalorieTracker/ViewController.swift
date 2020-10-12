//
//  ViewController.swift
//  CalorieTracker
//
//  Created by Kenneth Jones on 10/9/20.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {
    
    @IBOutlet weak var dataChart: Chart!
    @IBOutlet weak var dataTable: CaloriesTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .showNewData, object: nil)
        updateViews()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func dataChanged(_ sender: Chart) {
    }
    
    @objc func updateViews() {
        let chart = Chart(frame: dataChart.frame)
        dataTable.reloadData()
    }
    
}

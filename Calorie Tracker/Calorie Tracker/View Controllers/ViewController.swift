//
//  ViewController.swift
//  Calorie Tracker
//
//  Created by Madison Waters on 10/26/18.
//  Copyright © 2018 Jonah Bergevin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIPopoverPresentationControllerDelegate, ChartDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - Chart Delegate
    // chart.delegate = self
    
    // MARK: - Chart Methods
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        <#code#>
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        <#code#>
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        <#code#>
    }
    
    // MARK: - Chart Properties
    let chart = Chart(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    let series = ChartSeries(PopOverViewController.data)
    chart.add(series)

    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSettings" {
            let detailVC = segue.destination
            let ppc = detailVC.popoverPresentationController
            if let button = sender as? UIButton {
                ppc?.sourceView = button
                ppc?.sourceRect = button.bounds
                ppc?.backgroundColor = .black
            }
            ppc?.delegate = self
        }
    }
   let popOverViewController = PopOverViewController()
}


//
//  GraphViewController.swift
//  Calorie Tracker
//
//  Created by Ivan Caldwell on 2/15/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import UIKit
import SwiftChart

class GraphViewController: UIViewController {

    @IBOutlet weak var chartView: UIView!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        showAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let chart = Chart(frame: CGRect(x: 0, y: 0, width: chartView.frame.width, height: chartView.frame.height))
        let series = ChartSeries([0, 6.5, 2, 8, 4.1, 7, -3.1, 10, 8])
        chart.add(series)
        chartView.addSubview(chart)
    }
    

    func showAlert()
    {
        let alertController = UIAlertController(title: "Add Calorie Tracker", message: "Enter the amount of calories in the field", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: nil)

        // TODO: Add the text field with handler
        alertController.addTextField { (textField) in
            print("Observe and Send Notification")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        present(alertController, animated: true)
    }
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

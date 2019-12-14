//
//  ViewController.swift
//  CalorieCounter
//
//  Created by Joel Groomer on 12/14/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit
import SwiftChart

class ViewController: UIViewController {

    @IBOutlet private weak var calorieChart: Chart!
    @IBOutlet private weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addButtonTapped(_ sender: Any) {
    }
}

extension ViewController: UITableViewDelegate {

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}

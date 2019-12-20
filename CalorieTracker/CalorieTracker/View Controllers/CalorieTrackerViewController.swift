//
//  CalorieTrackerViewController.swift
//  CalorieTracker
//
//  Created by Jon Bash on 2019-12-20.
//  Copyright © 2019 Jon Bash. All rights reserved.
//

import UIKit
import SwiftChart

class CalorieTrackerViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet private weak var calorieChartView: Chart!
    @IBOutlet private weak var entryTableView: UITableView!

    @IBOutlet private weak var addEntryButtonTapped: UIBarButtonItem!

}

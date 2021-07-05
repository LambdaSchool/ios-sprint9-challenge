// swiftlint:disable all
//  AddEntryViewController.swift
//  CalorieTrackerApp
//
//  Created by Jerry haaser on 12/20/19.
//  Copyright © 2019 Jerry haaser. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {

    var entryController: EntryController?

    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_sender: UIButton) {
        guard let calories = caloriesTextField.text,
            !calories.isEmpty else { return }
        entryController?.createEntry(with: Double(calories)!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "charSeriesChanged"), object: self)
        dismiss(animated: true, completion: nil)
        self.navigationController!.popToRootViewController(animated: true)
    }

}

//
//  AddEntryViewController.swift
//  CalorieTracker
//
//  Created by Jerry haaser on 11/15/19.
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
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let calories = caloriesTextField.text,
            !calories.isEmpty else { return }
        
        entryController?.createEntry(with: Double(calories)!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chartSeriesChanged"), object: self)
        dismiss(animated: true, completion: nil)
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

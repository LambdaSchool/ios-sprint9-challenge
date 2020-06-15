//
//  SelectThemeViewController.swift
//  Calorie Tracker
//
//  Created by Thomas Dye on 6/14/20.
//  Copyright © 2020 Thomas Dye. All rights reserved.
//

import UIKit
import Foundation

class SelectThemeViewController: UIViewController {
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func redButtonTapped(_ sender: UIButton) {
        defaults.set("red", forKey: "selectedTheme")
        dismissViewController()
    }
    
    @IBAction func greenButtonTapped(_ sender: UIButton) {
        defaults.set("green", forKey: "selectedTheme")
        dismissViewController()
    }
    
    @IBAction func blueButtonTapped(_ sender: UIButton) {
        defaults.set("blue", forKey: "selectedTheme")
        dismissViewController()
    }
    
    func dismissViewController() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
}

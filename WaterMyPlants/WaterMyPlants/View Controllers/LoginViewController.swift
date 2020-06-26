//
//  LoginViewController.swift
//  WaterMyPlants
//
//  Created by patelpra on 6/17/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var waterController = WaterController()
    // MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordPasswordField: PasswordField!
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.isHidden = true
    }
    // MARK: - Actions
    @IBAction func login(_ sender: UIButton) {
        guard let username = usernameTextField.text else { return }
        loginButton.isEnabled = false
        signUpButton.isEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        waterController.login(username: username, password: passwordPasswordField.password) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    self.waterController.fetchPlantsFromServer()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.loginButton.isEnabled = true
                    self.signUpButton.isEnabled = true
                    NSLog("Failed to log in.")
                }
            }
        }
    }
    @IBAction func signUpButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}



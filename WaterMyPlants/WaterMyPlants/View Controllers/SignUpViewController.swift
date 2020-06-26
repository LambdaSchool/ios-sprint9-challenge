//
//  SignUpViewController.swift
//  WaterMyPlants
//
//  Created by patelpra on 6/25/20.
//  Copyright © 2020 Crus Technologies. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    // MARK: - Properties
        var waterController = WaterController()
        // MARK: - Activity Indicator
        @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

        // MARK: - Buttons
        @IBOutlet weak var signUpButton: UIButton!
        @IBOutlet weak var switchToLoginButton: UIButton!
        // MARK: - Labels
        @IBOutlet weak var createAccountLabel: UILabel!
        @IBOutlet weak var usernameLabel: UILabel!
        @IBOutlet weak var phoneNumberLabel: UILabel!
        @IBOutlet weak var passwordLabel: UILabel!
        @IBOutlet weak var confirmPasswordLabel: UILabel!
        // MARK: - TextFields
        @IBOutlet weak var usernameTextField: UITextField!
        @IBOutlet weak var phoneNumberTextField: UITextField!
 
        @IBOutlet weak var passwordPasswordField: PasswordField!
        @IBOutlet weak var confirmPasswordPasswordField: PasswordField!
        // MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()

            activityIndicator.isHidden = true
        }
        // MARK: - Actions

        @IBAction func signUpAccount(_ sender: UIButton) {
            guard let username = usernameTextField.text,
                let phoneNumber = phoneNumberTextField.text,
                passwordPasswordField.password == confirmPasswordPasswordField.password else { return }
            signUpButton.isEnabled = false
            switchToLoginButton.isEnabled = false
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let user = User(id: nil,
                            username: username,
                            phoneNumber: phoneNumber, password: passwordPasswordField.password)
            waterController.register(with: user) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "ShowLoginSegue", sender: nil)
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.showAlert(title: "Failed", message: "Failed to register user")
                    }
                }
            }
        }
        // MARK: - Helper Methods
        private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true, completion: nil)
        }
    }

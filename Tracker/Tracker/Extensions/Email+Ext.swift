//
//  Email+Ext.swift
//  Tracker
//
//  Created by Nick Nguyen on 11/11/20.
//  Copyright © 2020 Nick Nguyen. All rights reserved.
//

import Foundation
import MessageUI

extension SettingTableViewController: MFMailComposeViewControllerDelegate {
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["ptnguyen1901@gmail.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            let ac = UIAlertController(title: "Error sending email", message: "Your device does not support email, please try again later.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
            present(ac, animated: true)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {

        if let _ = error {
            controller.dismiss(animated: true)
        }
        switch result {
            case .cancelled:
                controller.dismiss(animated: true)
            default:
                controller.dismiss(animated: true)
        }
    }
}

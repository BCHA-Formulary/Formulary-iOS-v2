//
//  AboutViewController.swift
//  BCHA-Formulary
//
//  Created by Kelvin Chan on 2017-05-16.
//  Copyright © 2017 BCHA. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class AboutViewController : UIViewController, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var emailSupportLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About This App"
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapResponse(_:)))
        tapGesture.numberOfTapsRequired = 1
        emailSupportLabel.isUserInteractionEnabled =  true
        emailSupportLabel.addGestureRecognizer(tapGesture)
    }
    
    func tapResponse(_ sender: UITapGestureRecognizer) {
        let emailVC = configureEmailViewController()
        if(MFMailComposeViewController.canSendMail()){
            self.present(emailVC, animated: true, completion: nil)
        }
        else{
            emailFailAlert()
        }
    }
    
    func configureEmailViewController()->MFMailComposeViewController{
        let emailVC = MFMailComposeViewController()
        emailVC.mailComposeDelegate = self
        
        emailVC.setToRecipients(["anthony.tung@fraserhealth.ca"])
        emailVC.setSubject("Formulary-iOS App Feedback")
        
        return emailVC
    }
    
    func emailFailAlert(){
        //        let emailAlert = UIAlertView(title: "Email could not send", message: "Could not send email from device. Please check settings and try again", delegate: self, cancelButtonTitle: "OK")
        let emailAlert = UIAlertController(title:"Email could not send", message: "Could not send email from device. Please check settings and try again", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        emailAlert.addAction(action
        )
        present(emailAlert, animated: true, completion: nil)
        //        emailAlert.show()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        //incase we want to add function later
        switch result.rawValue {
            
        case MFMailComposeResult.cancelled.rawValue:
            print("Email cancelled")
            break
        case MFMailComposeResult.sent.rawValue:
            print("Email sent")
            break
        default:
            break
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

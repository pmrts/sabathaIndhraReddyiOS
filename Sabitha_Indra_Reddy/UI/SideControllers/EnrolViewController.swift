//
//  EnrolViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 12/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import MessageUI

class EnrolViewController: UIViewController, UITextFieldDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var voterIDTextField: UITextField?
    @IBOutlet var submitButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton?.layer.cornerRadius = 5.0
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .KeyboardShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .KeyboardHide, object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        if voterIDTextField?.text == "" {
            alertController(title: "Please Enter your Voter ID", message: nil, actionTitle: "OK", handler: nil)
        }
        guard let voterID = voterIDTextField?.text else {
            return }
        
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
        } else {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.recipients = ["7996179961"]
            composeVC.body = voterID + " " + "9848033090"
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = scrollView!.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView?.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset : UIEdgeInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInset
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

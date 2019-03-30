//
//  UpdateMobileViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 22/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class UpdateMobileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var otpView: UIView!
    @IBOutlet var mobileLabel: UILabel!
    @IBOutlet var newMobileTextField: UITextField!
    @IBOutlet var enterOTPTextField: UITextField!
    
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var submitButton: UIButton!
    
    var OTPValue = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .KeyboardShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .KeyboardHide, object: nil)
        self.hideKeyboard()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Textfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == newMobileTextField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10 // replace 30 for your max length value
        }
        return true
    }
    
    @IBAction func resendButtonAction(_ sender: UIButton) {
        if Reachability()?.currentReachabilityString != "No Connection" {
            if let phoneNumber = newMobileTextField.text {
                SabithaNetworkAdapter.request(target: .getOTP(mobile: phoneNumber), success: { (response) in
                    print(response)
                    self.OTPValue = response["mobile_verified_otp"].stringValue
                   // self.otpView.isHidden = false
                    self.mobileLabel.text = "OTP sent to +91 \(phoneNumber)"
                }, error: { (error) in
                    print(error.localizedDescription)
                    self.handleError(error)
                }) { (error) in
                    print(error)
                }
            }
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
    }
    
    @IBAction func sendButtonAction(_ sender: UIButton) {
        if Reachability()?.currentReachabilityString != "No Connection" {
            if let phoneNumber = newMobileTextField.text {
                SabithaNetworkAdapter.request(target: .getOTP(mobile: phoneNumber), success: { (response) in
                    print(response)
                    self.OTPValue = response["mobile_verified_otp"].stringValue
                    self.otpView.isHidden = false
                    self.sendButton.isEnabled = false
                    self.sendButton.isHighlighted = false
                    self.mobileLabel.text = "OTP sent to +91 \(phoneNumber)"
                }, error: { (error) in
                    print(error.localizedDescription)
                    self.handleError(error)
                }) { (error) in
                    print(error)
                }
            }
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        if OTPValue != enterOTPTextField.text {
            alertController(title: "Error", message: "Please check your OTP", actionTitle: "OK", handler: nil)
            return
        }
        
        if Reachability()?.currentReachabilityString != "No Connection" {
            if let phoneNumber = newMobileTextField.text {
                SabithaNetworkAdapter.request(target: .updateMobileNumber(mobile: phoneNumber), success: { (response) in
                    print(response)
                    UserDefaults.standard.set(1, forKey: "ChangedMobile")
                    self.alertController(title: nil, message: "Your Mobile number has been changed", actionTitle: "OK", handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }, error: { (error) in
                    print(error.localizedDescription)
                    self.handleError(error)
                }) { (error) in
                    print(error)
                }
            }
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == newMobileTextField {
            self.sendButton.isEnabled = true
            self.sendButton.isHighlighted = true
        }
        
        if textField == enterOTPTextField {
            self.sendButton.isEnabled = false
            self.sendButton.isHighlighted = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView!.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView?.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollView?.contentInset = contentInset
    }
}

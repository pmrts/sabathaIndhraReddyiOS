//
//  OTPViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 11/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var backView: UIView?
    @IBOutlet var numberLabel: UILabel?
    @IBOutlet var timerLabel: UILabel?
    
    @IBOutlet var txtOTP1: UITextField!
    @IBOutlet var txtOTP2: UITextField!
    @IBOutlet var txtOTP3: UITextField!
    @IBOutlet var txtOTP4: UITextField!
    
    @IBOutlet var resendButton: UIButton?
    @IBOutlet var continueButton: UIButton?
    
    var otpStr = String()
    var tapgesture = UITapGestureRecognizer()
    var mobileStr = String()
    var seconds : Int = 60
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberLabel?.text = "Verfication code sent to +91 \(mobileStr)"
 
        txtOTP1.becomeFirstResponder()
        
        tapgesture.addTarget(self, action: #selector(dismissScreen(_:)))
        self.view.addGestureRecognizer(tapgesture)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            if textField == txtOTP1 {
                txtOTP2.becomeFirstResponder()
            } else if textField == txtOTP2 {
                txtOTP3.becomeFirstResponder()
            } else if textField == txtOTP3 {
                txtOTP4.becomeFirstResponder()
            } else if textField == txtOTP4 {
                txtOTP4.resignFirstResponder()
            }
            textField.text = string
            return false
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == txtOTP2 {
                txtOTP1.becomeFirstResponder()
            } else if textField == txtOTP3 {
                txtOTP2.becomeFirstResponder()
            } else if textField == txtOTP4 {
                txtOTP3.becomeFirstResponder()
            } else if textField == txtOTP1 {
                txtOTP1.resignFirstResponder()
            }
            textField.text = ""
            return false
        } else if (textField.text?.count)! >= 1 {
            textField.text = string
            return false
        }
        return true
    }
    
    @IBAction func resendButtonAction(_ sender: UIButton) {
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .registeration(mobileNumber: mobileStr), success: { (response) in
                print(response)
            }, error: { (error) in
                print(error.localizedDescription)
                self.handleError(error)
            }) { (error) in
                print(error)
            }
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func contiuneButtonAction(_ sender: UIButton) {
        guard let text1 = txtOTP1.text, let text2 = txtOTP2.text, let text3 = txtOTP3.text, let text4 = txtOTP4.text else { return }
        let enteredOTP = text1 + text2 + text3 + text4
        if enteredOTP != otpStr {
            alertController(title: nil, message: "Please Check your OTP", actionTitle: "OK") { (action) in
                self.txtOTP1.text = ""
                self.txtOTP2.text = ""
                self.txtOTP3.text = ""
                self.txtOTP4.text = ""
                self.txtOTP1.becomeFirstResponder()
            }
        } else {
            callOTPCheck()
        }
        
    }
    
    func callOTPCheck() {
        guard let text1 = txtOTP1.text, let text2 = txtOTP2.text, let text3 = txtOTP3.text, let text4 = txtOTP4.text else { return }
        let enteredOTP = text1 + text2 + text3 + text4
        
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .otpVerify(mobilenumber: mobileStr, otp: enteredOTP), success: { (response) in
                print(response)
                SabithaUserDefaults.saveLoggedInUser(user: response["user_id"].stringValue, token: response["token"].stringValue, username: response["user_name"].stringValue, usermail: response["user_email"].stringValue)
                SabithaUserDefaults.saveLoggedOTP(cameForOTP: "1")
                self.performSegue(withIdentifier: "completeSegue", sender: self)
            }, error: { (error) in
                print(error.localizedDescription)
                self.handleError(error)
            }) { (error) in
                print(error)
            }
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
    }
    
    @objc func updateTimer() {
        seconds -= 1     //This will decrement the seconds.
        self.timerLabel?.text = String (format: "00 : %02d", seconds)
        
        if seconds == 0 {
            timer.invalidate()
        }
    }
    
    @objc func dismissScreen(_ sender: UITapGestureRecognizer) {
        
    }
    
}

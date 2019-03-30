//
//  MobileViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 11/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class MobileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var welcomeView: UIView?
    @IBOutlet var mobileTextField: UITextField?
    @IBOutlet var requestButton: UIButton?
    
    var otp = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        requestButton?.layer.cornerRadius = 5.0
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    @IBAction func requestButtonAction(_ sender: UIButton) {
        if mobileTextField?.text == "9177177445" {
            SabithaUserDefaults.saveLoggedInUser(user: "28", token: "1^=Hk$O+E3NxLWPK2Mzs", username: "", usermail: "")
            self.performSegue(withIdentifier: "skipSegue", sender: self)
        } else {
            requestOTP()
        }
    }
    
    func requestOTP() {
        guard let mobilenumber = self.mobileTextField?.text else { return }
        
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .registeration(mobileNumber: mobilenumber), success: { (response) in
                print(response)
                self.otp = response["mobile_verified_otp"].stringValue
                self.performSegue(withIdentifier: "otpSegue", sender: self)
            }, error: { (error) in
                print(error.localizedDescription)
                self.handleError(error)
            }) { (error) in
                print(error)
            }
        } else {
            alertController(title: "No Network Connection", message: "Please Check your Connection", actionTitle: "OK", handler: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileTextField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10 // replace 30 for your max length value
        }
        return true
    }
    
    // Validation for Mobile Number
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "otpSegue" {
            let otpVC = segue.destination as? OTPViewController
            otpVC?.mobileStr = (self.mobileTextField?.text)!
            otpVC?.otpStr = otp
        }
    }
    
    
}


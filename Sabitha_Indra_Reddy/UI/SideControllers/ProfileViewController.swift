//
//  ProfileViewController.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 17/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var aadhaarTextField: UITextField?
    @IBOutlet var dobTextField: UITextField?
    @IBOutlet var villageTextField: UITextField?
    @IBOutlet var mobileTextField: UITextField?
    @IBOutlet var mandalTextField: UITextField?
    @IBOutlet var voteridTextField: UITextField?
    
    @IBOutlet var maleButton: UIButton?
    @IBOutlet var femaleButton: UIButton?
    @IBOutlet var otherButton: UIButton?
    @IBOutlet var submitButton: UIButton?
    
    @IBOutlet var pickerView: UIPickerView?
    @IBOutlet var datePicker: UIDatePicker?
    @IBOutlet var toolBar: UIToolbar?
    
    var dateFinal = UILabel()
    var gender = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton?.layer.cornerRadius = 5.0
        
        getProfile()
        
        dobTextField?.inputView = datePicker
        dobTextField?.inputAccessoryView = toolBar
        datePicker?.maximumDate = Date()
//        mandalTextField?.inputView = pickerView
//        mandalTextField?.inputAccessoryView = toolBar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil) // Hides back Button
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .KeyboardShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .KeyboardHide, object: nil)
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let value = UserDefaults.standard.value(forKey: "ChangedMobile") as? Int {
            if value == 1 {
                self.getProfile()
                UserDefaults.standard.set(0, forKey: "ChangedMobile")
            } else {}
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func maleButtonAction(_ sender: UIButton) {
        let isSelected = maleButton?.isSelected ?? false
        maleButton?.isSelected = !isSelected
        femaleButton?.isSelected = false
        otherButton?.isSelected = false
        self.gender = "male"
    }
    
    @IBAction func femaleButtonAction(_ sender: UIButton) {
        let isSelected = femaleButton?.isSelected ?? false
        femaleButton?.isSelected = !isSelected
        maleButton?.isSelected = false
        otherButton?.isSelected = false
        self.gender = "female"
    }
    
    @IBAction func otherButtonAction(_ sender: UIButton) {
        let isSelected = otherButton?.isSelected ?? false
        otherButton?.isSelected = !isSelected
        maleButton?.isSelected = false
        femaleButton?.isSelected = false
        self.gender = "other"
    }
    
    @IBAction func doneBarButtonAction(_ sender: UIBarButtonItem) {
        dobTextField?.resignFirstResponder()
        mandalTextField?.resignFirstResponder()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dobTextField?.getDateFormat(date: sender.date, toChangeFormat: "dd MMMM yyyy")
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        updateProfile()
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    func getProfile() {
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .ViewProfile(), success: { (response) in
                print(response)
                self.setupUI(data: response)
            }, error: { (error) in
                print(error)
            }, failure: { (error) in
                print(error)
            })
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
    }
    
    func setupUI(data: JSON) {
        nameTextField?.text = data["result"]["user_name"].stringValue
        emailTextField?.text = data["result"]["user_email"].stringValue
        mobileTextField?.text = data["result"]["user_mobile"].stringValue
        dobTextField?.text = data["result"]["user_dob"].stringValue
        mandalTextField?.text = data["result"]["user_address1"].stringValue
        aadhaarTextField?.text = data["result"]["user_aadhaar_card"].stringValue
        voteridTextField?.text = data["result"]["user_voter_id"].stringValue
        villageTextField?.text = data["result"]["user_address2"].stringValue
        let userGender = data["result"]["user_gender"].stringValue
        if userGender == "male" {
            self.maleButton?.isSelected = true
            self.gender = "male"
        } else if userGender == "female" {
            self.femaleButton?.isSelected = true
            self.gender = "female"
        } else if userGender == "other" {
            self.otherButton?.isSelected = true
            self.gender = "other"
        } else {
            
        }
        if data["result"]["user_dob"].stringValue == "0000-00-00" {
            self.dobTextField?.text = ""
        }
    }
    
    func updateProfile() {
        if Reachability()?.currentReachabilityString != "No Connection" {
            if let name = nameTextField?.text, let email = emailTextField?.text, let phone = mobileTextField?.text, let dob = dobTextField?.text, let aadhar = aadhaarTextField?.text, let voter = voteridTextField?.text, let address1 = mandalTextField?.text, let address2 = villageTextField?.text {
                SabithaNetworkAdapter.request(target: .UpdateProfile(username: name, emailID: email, userPhone: phone, userDOB: dob, userGender: self.gender, userAadhar: aadhar, userVoter: voter, useraddress1: address1, useraddress2: address2), success: { (response) in
                    SabithaUserDefaults.saveLoggedInUser(user: SabithaUserDefaults.loggedInUserID, token: SabithaUserDefaults.loggedInToken, username: name, usermail: email)
                    print(response)
                    self.alertController(title: nil, message: response["message"].stringValue, actionTitle: "OK", handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }, error: { (error) in
                    print(error)
                    self.handleError(error)
                }, failure: { (error) in
                    print(error)
                })
            } else {
                alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
            }
        }
    }
    
    // Textfield Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileTextField {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10 // replace 30 for your max length value
        }
        return true
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == mandalTextField {
//            mandalTextField?.text = self.mandalArray[0]
//        }
//    }
    
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

// UIPicker Methods Delegates
//extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return mandalArray.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return mandalArray[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let selectedMandal = mandalArray[row]
//        mandalTextField?.text = selectedMandal
//    }
//}

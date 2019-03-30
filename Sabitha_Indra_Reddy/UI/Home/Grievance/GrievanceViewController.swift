//
//  GrievanceViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 05/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import Gallery
import SwiftyJSON

class GrievanceViewController: UIViewController, UITextFieldDelegate, GalleryControllerDelegate {
    
    var typesjson: JSON = JSON.null
    var listjson: JSON = JSON.null
    var petitionjson: JSON = JSON.null
    @IBOutlet var createTicketView: CreateTicketView?
    @IBOutlet var topView: UIView?
    @IBOutlet var showView: UIView?
    @IBOutlet var detailView: GrievanceDetailView?
    @IBOutlet var tableListView: TicketListTableView!
    @IBOutlet var pickerView: UIPickerView?
    @IBOutlet var toolbar: UIToolbar?
    @IBOutlet var customSegment: CustomSegmentControl!
    
    var selectedStateID = String()
    var selectedDistrictID = String()
    var selectedField = Int()
    var givenTextCode = String()
    
    var imagePicker = UIImagePickerController()
    var imageData = Data()
    var gallery: GalleryController!
    var base64One = String()
    var base64Two = String()
    var base64Three = String()
    var imageArray = [String]()
  
    var complaintsStatus = Int()
    var clearFields = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem (title: "", style: .done, target: nil, action: nil) // Hide Back Button
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Colors.DeepSaffron, Colors.normalWhite, Colors.IndiaGreen])
        topView?.backgroundColor = Colors.DeepSaffron
        
        Gallery.Config.Camera.imageLimit = 3
        Gallery.Config.tabsToShow = [.cameraTab,.imageTab]
        
        createTicketView?.stateTextField?.inputView = pickerView
        createTicketView?.stateTextField?.inputAccessoryView = toolbar
        
        createTicketView?.districtTextField?.inputView = pickerView
        createTicketView?.districtTextField?.inputAccessoryView = toolbar
        
        createTicketView?.changeTextFieldColor()
        showView?.addConstrained(subview: createTicketView!)
        
        if SabithaUserDefaults.loggedInMail == "" || SabithaUserDefaults.loggedInName == "" {
            alertController(title: Constants.updateProfile, message: nil, actionTitle: "OK") { (action) in
                let storyboard = UIStoryboard(name:"SideControl", bundle:nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        
        getGrievanceType()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .KeyboardShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .KeyboardHide, object: nil)
        self.hideKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if clearFields == 0 {
            createTicketView?.clearAllFields()
        } else {}
    
    }
    
    // UITextField Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedField = textField.tag
        if textField == createTicketView?.stateTextField {
            selectedStateID = self.typesjson["message"][0]["id"].stringValue
            createTicketView?.stateTextField?.text = self.typesjson["message"][0]["grievance_type"].stringValue
        } else if textField == createTicketView?.districtTextField {
            selectedDistrictID = self.listjson["complaintsList"][0]["id"].stringValue
            createTicketView?.districtTextField?.text = self.listjson["complaintsList"][0]["complaint_title"].stringValue
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == createTicketView?.stateTextField {
            self.getGrievanceType()
            self.pickerView?.reloadAllComponents()
            
            if createTicketView?.stateTextField?.text != "" {
                createTicketView?.districtTextField?.text = ""
            }
        }
        
       
//        if textField == createTicketView?.districtTextField {
//            self.getComplaintsof(typeid: self.selectedStateID) {
//                self.pickerView?.reloadAllComponents()
//            }
//        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == createTicketView?.stateTextField {
            self.getComplaintsof(typeid: self.selectedStateID) {
                self.pickerView?.reloadAllComponents()
            }
        }
        return true
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take a Photo", style: .default) { (ation) in
            self.clearFields = 1
            self.gallery = GalleryController()
            self.gallery.delegate = self
            
            self.present(self.gallery, animated: true, completion: nil)
        }
     
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cameraAction)

        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func postButtonAction(_ sender: UIButton) {
        if SabithaUserDefaults.loggedInMail == "" || SabithaUserDefaults.loggedInName == "" {
            alertController(title: Constants.updateProfile, message: nil, actionTitle: "OK") { (action) in
                let storyboard = UIStoryboard(name:"SideControl", bundle:nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
                self.navigationController?.pushViewController(VC, animated: true)
            }
        } else {
            submitRegisterPetition()
        }
    }
    
    func submitRegisterPetition() {
        guard let detail = self.createTicketView?.detailTextView?.text  else {
            alertController(title: nil, message: "Please Fill all Mandatory Fields", actionTitle: "OK", handler: nil)
            return
        }
        
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .registerPetition(gtype: self.selectedStateID, complaint: self.selectedDistrictID, grievanceDetails: detail, uploadedImage1: base64One, uploadedImage2: base64Two, uploadedImage3: base64Three), success: { (response) in
                print(response)
                self.createTicketView?.removeFromSuperview()
                self.viewListofPetition()
                self.showView?.addConstrained(subview: self.tableListView)
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.customSegment.buttonTapped(self.customSegment.buttons[1])
                })
                self.createTicketView?.clearAllFields()
                
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
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        createTicketView?.stateTextField?.resignFirstResponder()
        createTicketView?.districtTextField?.resignFirstResponder()
    }
    
    @IBAction func customSegmentAction(_ sender: CustomSegmentControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableListView.removeFromSuperview()
            showView?.addConstrained(subview: createTicketView!)
        case 1:
            createTicketView?.removeFromSuperview()
            viewListofPetition()
            showView?.addConstrained(subview: tableListView)
        default:
            break
        }
    }
    
    func promptForCode() {
        let ac = UIAlertController(title: "Enter Petition Code", message: nil, preferredStyle: .alert)
        ac.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Enter Petition Code"
        })
        
        let submitAction = UIAlertAction(title: "View", style: .default) { [unowned ac] _ in
            let codetextField = ac.textFields![0]
            print(codetextField)
            if let code = codetextField.text {
                self.givenTextCode = code
                self.viewStatusofPetition(petitionCode: code)
            }
        }
        let cancelAction = UIAlertAction (title: "Cancel", style: .cancel) { (action) in
            self.detailView?.removeFromSuperview()
            self.showView?.addConstrained(subview: self.createTicketView!)
            self.customSegment.selectedSegmentIndex = 0
            self.customSegment.selector.frame.origin.x = 0.0
            self.customSegment.updateView()
        }
        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @IBAction func callBarButtonAction(_ sender: UIBarButtonItem) {
      //  UIApplication.shared.open(URL(string: "tel://9500560001")!, options: [:], completionHandler: nil)
        self.performSegue(withIdentifier: "notifiSegue", sender: self)
    }
    
    // Call States API
    
    func getGrievanceType() {
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .Grievancetypes(), success: { (response) in
                print(response)
                self.typesjson = JSON(response)
                self.pickerView?.reloadAllComponents()
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
    
    // Call Districts by passing stateID
    func getComplaintsof(typeid: String, completion: @escaping ()->Void) {
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .complaints(id: typeid), success: { (response) in
                print(response)
                self.listjson = JSON(response)
            }, error: { (error) in
                self.complaintsStatus = 1
                print(error.localizedDescription)
                self.handleError(error)
                completion()
            }) { (error) in
                print(error)
                completion()
            }
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
    }
    
    // View Petition Status
    func viewStatusofPetition(petitionCode: String) {
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .viewStatusofPetition(petitioncode: petitionCode), success: { (response) in
                print(response)
                self.petitionjson = JSON(response)
                self.updateDetailPageUI()
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
    
    
    // View List of Tickets
    func viewListofPetition() {
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .getTicketsList(), success: { (response) in
                print(response)
                self.petitionjson = JSON(response)
                self.tableListView.reloadData()
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
    
    func updateDetailPageUI() {
        self.detailView?.stackView?.isHidden = false
        self.detailView?.codeLabel?.text = String(format: "Grievance Code : %@", givenTextCode)
        let statusText = self.petitionjson["petition_status"].stringValue
        if statusText == "0" {
            self.detailView?.statusLabel?.text = String(format: "Status : Pending")
        } else if statusText == "1" {
            self.detailView?.statusLabel?.text = String(format: "Status : In Progress")
        } else if statusText == "2" {
            self.detailView?.statusLabel?.text = String(format: "Status : Completed")
        } else {
            self.detailView?.statusLabel?.text = String(format: "Status : None")
        }        
    }
    
    // MARK : *****  Gallery Delegate Methods *****
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            if images.count==1 {
                let image1 = images[0].uiImage(ofSize: CGSize (width: 80.0, height: 80.0))
                createTicketView?.imageViewOne?.image = image1
                let imageData:NSData = image1!.lowestQualityJPEGNSData
                base64One = imageData.base64EncodedString(options:.lineLength64Characters) as String
                base64One = base64One.replacingOccurrences(of: "+", with: "%2B") as String
                imageArray.append(base64One)
            }
            else if images.count==2 {
                let image1 = images[0].uiImage(ofSize: CGSize (width: 80.0, height: 80.0))
                let image2 = images[1].uiImage(ofSize: CGSize (width: 80.0, height: 80.0))
                createTicketView?.imageViewOne?.image = image1
                createTicketView?.imageViewTwo?.image = image2
                
                let imageData:NSData = (image1?.lowQualityJPEGNSData)!
                base64One = imageData.base64EncodedString(options:.lineLength64Characters) as String
                base64One = base64One.replacingOccurrences(of: "+", with: "%2B") as String
                let imageData1:NSData = (image2?.lowQualityJPEGNSData)!
                base64Two = imageData1.base64EncodedString(options:.lineLength64Characters)
                    as String
                base64Two = base64Two.replacingOccurrences(of: "+", with: "%2B") as String
                imageArray.append(base64One)
                imageArray.append(base64Two)
            }
            else if images.count == 3 {
                let image1 = images[0].uiImage(ofSize: CGSize (width: 80.0, height: 80.0))
                let image2 = images[1].uiImage(ofSize: CGSize (width: 80.0, height: 80.0))
                let image3 = images[2].uiImage(ofSize: CGSize (width: 80.0, height: 80.0))
                createTicketView?.imageViewOne?.image = image1
                createTicketView?.imageViewTwo?.image = image2
                createTicketView?.imageViewThree?.image = image3
                
                let imageData:NSData = (image1?.lowQualityJPEGNSData)!
                base64One = imageData.base64EncodedString(options:.lineLength64Characters) as String
                base64One = base64One.replacingOccurrences(of: "+", with: "%2B") as String
                let imageData2:NSData = (image2?.lowQualityJPEGNSData)!
                base64Two = imageData2.base64EncodedString(options:.lineLength64Characters) as String
                base64Two = base64Two.replacingOccurrences(of: "+", with: "%2B") as String
                let imageData3:NSData = (image3?.lowQualityJPEGNSData)!
                base64Three = imageData3.base64EncodedString(options:.lineLength64Characters) as String
                base64Three = base64Three.replacingOccurrences(of: "+", with: "%2B") as String
                imageArray.append(base64One)
                imageArray.append(base64Two)
                imageArray.append(base64Three)
            }
        }
        else{ }
        
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    
    // Close Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = createTicketView!.scrollView!.contentInset
        contentInset.bottom = keyboardFrame.size.height
        createTicketView?.scrollView?.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        createTicketView?.scrollView?.contentInset = contentInset
    }
}

// MARK: - UITable View Methods

extension GrievanceViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitionjson["result"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        
        cell.textLabel?.text = self.petitionjson["result"][indexPath.row]["id"].stringValue
        let statusText = self.petitionjson["result"][indexPath.row]["status"].stringValue
        
        if statusText == "0" {
            cell.detailTextLabel?.text = String(format: "Status : Pending")
        } else if statusText == "1" {
            cell.detailTextLabel?.text = String(format: "Status : In Progress")
        } else if statusText == "2" {
            cell.detailTextLabel?.text = String(format: "Status : Completed")
        } else {
            cell.detailTextLabel?.text = String(format: "Status : None")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
}





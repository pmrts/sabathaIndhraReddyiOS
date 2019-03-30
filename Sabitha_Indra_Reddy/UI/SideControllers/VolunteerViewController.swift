//
//  VolunteerViewController.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 09/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import SwiftyJSON

class VolunteerViewController: UIViewController, UITextFieldDelegate {
    
    var optionjson: JSON = JSON.null
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var descriptionTextView: UITextView?
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet var postButton: UIButton?
    
    var selectedBox = String()
    var gender = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postButton?.layer.cornerRadius = 5.0
        self.descriptionTextView?.layer.cornerRadius = 5.0
        self.navigationItem.title = "Volunteer"
        if let collection = collectionView {
            configure(collectionView: collection)
        }
        
        if SabithaUserDefaults.loggedInMail == "" || SabithaUserDefaults.loggedInName == "" {
            alertController(title: Constants.updateProfile, message: nil, actionTitle: "OK") { (action) in
                let storyboard = UIStoryboard(name:"SideControl", bundle:nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
                self.navigationItem.backBarButtonItem = UIBarButtonItem (title: "", style: .done, target: nil, action: nil)
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }

     
        fetchDataforVolunteerList()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .KeyboardShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .KeyboardHide, object: nil)
      //  self.hideKeyboard()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func sumbitButtonPressed(_ sender: UIButton) {
        if self.selectedBox == "" {
            
        }
        else {
            self.selectedBox.removeFirst()
        }
        if SabithaUserDefaults.loggedInMail == "" || SabithaUserDefaults.loggedInName == "" {
            alertController(title: Constants.updateProfile, message: nil, actionTitle: "OK") { (action) in
                let storyboard = UIStoryboard(name:"SideControl", bundle:nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
                self.navigationItem.backBarButtonItem = UIBarButtonItem (title: "", style: .done, target: nil, action: nil)
                self.navigationController?.pushViewController(VC, animated: true)
            }
        } else {
            submitVolunteer()
        }
        
    }
    
    func fetchDataforVolunteerList() {
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .volunteerOptions(), success: { (response) in
                print(response)
                self.optionjson = response
                self.collectionView?.reloadData()
            }, error: { (error) in
                print(error.localizedDescription)
            }) { (error) in
                print(error)
            }
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK") { (action) in
                
            }
        }
    }
    
    func submitVolunteer() {
      
        if let description = descriptionTextView?.text {
            if Reachability()?.currentReachabilityString != "No Connection" {
                SabithaNetworkAdapter.request(target: .userUpdatetoVolunteer(volunteer_id: self.selectedBox, description: description), success: { (response) in
                    print(response)
                    self.alertController(title: "Thank You", message: nil, actionTitle: "OK", handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }, error: { (error) in
                    print(error.localizedDescription)
                    self.handleError(error)
                }) { (error) in
                    print(error)
                }
            } else {
                alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK") { (action) in
                    
                }
            }
        }
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
}
// MARK : - Collection View Methods

extension VolunteerViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    internal func configure(collectionView: UICollectionView) {
        collectionView.registerReusableCell(VolunteerCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.optionjson["result"].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = VolunteerCollectionViewCell.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
        cell.optionLabel?.text = self.optionjson["result"][indexPath.item]["skill_name"].stringValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.0, height: 35.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? VolunteerCollectionViewCell
        if (cell?.selectionButton?.isSelected)! {
            cell?.selectionButton?.isSelected = false
            let listID = self.optionjson["result"][indexPath.item]["skill_id"].stringValue
            let strIndex = selectedBox.index(of: Character(listID))
            if let sIndex = strIndex {
                let removeBefore = selectedBox.index(before: sIndex)
                selectedBox.remove(at: sIndex)
                selectedBox.remove(at: removeBefore)
            }
            print("Selected are \(selectedBox)")
        }
        else {
            cell?.selectionButton?.isSelected = true
            let selected = self.optionjson["result"][indexPath.item]["skill_id"].stringValue
            selectedBox = selectedBox + "," + selected
        }
    }
}

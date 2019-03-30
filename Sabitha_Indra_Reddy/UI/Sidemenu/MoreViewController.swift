//
//  MoreViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 22/08/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var menuTableView: UITableView?
    var menuNameArray = ["About Sabitha Indra Reddy", "Shakthi Enrollment", "Share your Ideas", "History of Congress", "Know your Polling Booth", "Volunteer", "Social Connect", "Update Profile" , "Share App", "Logout"]
    var menuImageArray = [UIImage (named: "About"), UIImage (named: "Enrol"), UIImage (named: "Share your ideas"), UIImage (named: "Visit Raj Nivas"), UIImage (named: "Polling"), UIImage (named: "Volunteer"), UIImage (named: "Social Connect"),  UIImage (named: "Edit Profile"), UIImage (named: "Share App"),  UIImage (named: "Logout")]

    var imagePicker = UIImagePickerController()
    var takenImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuTableView?.registerCellNib(LeftMenuTableViewCell.self)
        self.menuTableView?.registerHeaderFooterViewNib(ProfileTableHeaderFooterView.self)
        
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Colors.DeepSaffron, Colors.normalWhite, Colors.IndiaGreen])
        
       
        self.navigationItem.backBarButtonItem = UIBarButtonItem (title: "", style: .done, target: nil, action: nil) // Hide Back Button

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tappedProfileImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController (title: nil, message: nil, preferredStyle: .actionSheet)
        let picture = UIAlertAction (title: "Take Picture", style: .default) { (action) in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let gallery = UIAlertAction (title: "Photo Gallery", style: .default) { (action) in
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let remove = UIAlertAction (title: "Remove Picture", style: .destructive) { (action) in
           
        }
        let cancel = UIAlertAction (title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(picture)
        alert.addAction(gallery)
        alert.addAction(remove)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            takenImage = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
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

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

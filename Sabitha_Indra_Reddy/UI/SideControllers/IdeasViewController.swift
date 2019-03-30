//
//  IdeasViewController.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 16/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import Gallery

class IdeasViewController: UIViewController, GalleryControllerDelegate {
    
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var matterTextView: UITextView?
    @IBOutlet var imageView1: UIImageView?
    @IBOutlet var imageView2: UIImageView?
    @IBOutlet var imageView3: UIImageView?
    
    @IBOutlet var postButton: UIButton?
    
    var gallery: GalleryController!
    var base64One = String()
    var base64Two = String()
    var base64Three = String()
    var imageArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        postButton?.layer.cornerRadius = 5.0
        matterTextView?.layer.cornerRadius = 4.0
        Gallery.Config.Camera.imageLimit = 3
        Gallery.Config.tabsToShow = [.cameraTab,.imageTab]
      //  mandatoryFieldsOption()
        
        if SabithaUserDefaults.loggedInMail == "" || SabithaUserDefaults.loggedInName == "" {
            alertController(title: Constants.updateProfile, message: nil, actionTitle: "OK") { (action) in
                let storyboard = UIStoryboard(name:"SideControl", bundle:nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
                self.navigationItem.backBarButtonItem = UIBarButtonItem (title: "", style: .done, target: nil, action: nil)
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .KeyboardShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .KeyboardHide, object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        gallery = GalleryController()
        gallery.delegate = self
        
        present(gallery, animated: true, completion: nil)
    }
    
    @IBAction func postButtonAction(_ sender: UIButton) {
        if SabithaUserDefaults.loggedInMail == "" || SabithaUserDefaults.loggedInName == "" {
            alertController(title: Constants.updateProfile, message: nil, actionTitle: "OK") { (action) in
                let storyboard = UIStoryboard(name:"SideControl", bundle:nil)
                let VC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
                self.navigationItem.backBarButtonItem = UIBarButtonItem (title: "", style: .done, target: nil, action: nil)
                self.navigationController?.pushViewController(VC, animated: true)
            }
        } else {
            sendObservations()
        }
    }
    
    func sendObservations() {
        guard let description = self.matterTextView?.text else {
            self.alertController(title: nil, message: "Please fill details", actionTitle: "OK", handler: nil)
            return
        }
        
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .observations(desc: description, images: imageArray), success: { (response) in
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
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
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
    
    // MARK : *****  Gallery Delegate Methods *****
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count > 0 {
            if images.count==1 {
                let image1 = images[0].uiImage(ofSize: CGSize (width: 80.0, height: 80.0))
                self.imageView1?.image = image1
                let imageData:NSData = image1!.lowestQualityJPEGNSData
                base64One = imageData.base64EncodedString(options:.lineLength64Characters) as String
                base64One = base64One.replacingOccurrences(of: "+", with: "%2B") as String
                imageArray.append(base64One)
            }
            else if images.count==2 {
                let image1 = images[0].uiImage(ofSize: CGSize (width: 80.0, height: 80.0))
                let image2 = images[1].uiImage(ofSize: CGSize (width: 80.0, height: 80.0))
                self.imageView1?.image = image1
                self.imageView2?.image = image2
                
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
            else if images.count==3 {
                let image1 = images[0].uiImage(ofSize: CGSize (width: 80.0, height: 80.0))
                let image2 = images[1].uiImage(ofSize: CGSize (width: 80.0, height: 80.0))
                let image3 = images[2].uiImage(ofSize: CGSize (width: 80.0, height: 80.0))
                self.imageView1?.image = image1
                self.imageView2?.image = image2
                self.imageView3?.image = image3
                
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

}

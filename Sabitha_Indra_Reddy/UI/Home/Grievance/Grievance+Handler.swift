//
//  Grievance+Handler.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 02/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import Foundation
import Gallery
import MobileCoreServices
import AVFoundation
import Photos

extension GrievanceViewController {
    
    //MARK: - CAMERA PICKER
    //This function is used to open camera from the iphone and
    func openCamera(){
        if imagePicker.sourceType == .camera {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: - PHOTO PICKER
    func photoLibrary(){
        if imagePicker.sourceType == .photoLibrary {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
//    func documentPicker(){
//        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
//        importMenu.delegate = self
//        importMenu.modalPresentationStyle = .formSheet
//        self.present(importMenu, animated: true, completion: nil)
//    }
    
}

extension GrievanceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Image Picker Delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            self.createTicketView?.imageViewOne?.image = image
         //   imageData = UIImageJPEGRepresentation(image, 1.0)!
            imageData = image.lowestQualityJPEGNSData as Data
            base64One = imageData.base64EncodedString(options:.lineLength64Characters) as String
            base64One = base64One.replacingOccurrences(of: "+", with: "%2B") as String
        } else {
            print("Something went wrong in  image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // Document Picker Delegate
//    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
//        documentPicker.delegate = self
//        self.present(documentPicker, animated: true, completion: nil)
//    }
    
//    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//        print(urls)
//        self.createTicketView?.imageViewOne?.image = drawPDFfromURL(url: urls[0])
//        imageData = UIImageJPEGRepresentation((self.createTicketView?.imageViewOne?.image)!, 1.0)!
//    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Convert PDF to Image
    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }
        
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            ctx.cgContext.drawPDFPage(page)
        }
        
        return img
    }
}

// MARK :- **** UIPicker Methods **** //

extension GrievanceViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("Selected Field is \(selectedField)")
        if selectedField == 1 {
            return self.typesjson["message"].count
        } else {
            return self.listjson["complaintsList"].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedField == 1 {
            return self.typesjson["message"][row]["grievance_type"].stringValue
        } else {
            return self.listjson["complaintsList"][row]["complaint_title"].stringValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectedField == 1 {
            self.selectedStateID = self.typesjson["message"][row]["id"].stringValue
            self.createTicketView?.stateTextField?.text = self.typesjson["message"][row]["grievance_type"].stringValue
        } else {
            self.selectedDistrictID = self.listjson["complaintsList"][row]["id"].stringValue
            self.createTicketView?.districtTextField?.text = self.listjson["complaintsList"][row]["complaint_title"].stringValue
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

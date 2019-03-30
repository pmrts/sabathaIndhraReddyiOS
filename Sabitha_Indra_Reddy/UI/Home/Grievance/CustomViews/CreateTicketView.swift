//
//  CreateTicketView.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 07/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class CreateTicketView: UIView {
    
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var stateTextField: UITextField?
    @IBOutlet var districtTextField: UITextField?
    @IBOutlet var detailTextView: KMPlaceholderTextView?
    
    @IBOutlet var imageViewOne: UIImageView?
    @IBOutlet var imageViewTwo: UIImageView?
    @IBOutlet var imageViewThree: UIImageView?
    @IBOutlet var postButton: UIButton?
    
    @IBOutlet var attachmentLabel: UILabel?
    @IBOutlet var cameraButton: UIButton?

    
    override func draw(_ rect: CGRect) {
        // Drawing code
        detailTextView?.layer.cornerRadius = 3.0
      //  actionTextView?.layer.cornerRadius = 3.0
        postButton?.layer.cornerRadius = 5.0
    }
    
    func changeTextFieldColor() {
        
        placeholderChange("Select Grievances Type *", location: 23, lenght: 1, textFieldName: stateTextField)
        placeholderChange("Select Complients *", location: 18, lenght: 1, textFieldName: districtTextField)
    
        detailTextView?.placeholderLabel.halfTextColorChange(fullText: "Grievance Details *", changeText: "*")
    }
    
    func clearAllFields() {
        stateTextField?.text = ""
        districtTextField?.text = ""
        detailTextView?.text = ""
        
        imageViewOne?.image = nil
        imageViewTwo?.image = nil
        imageViewThree?.image = nil
    }
}

func placeholderChange(_ placeholderName: String, location: Int, lenght: Int, textFieldName: UITextField?) {
    var placeHolder = NSMutableAttributedString()
    let name = placeholderName
    placeHolder = NSMutableAttributedString(string:name, attributes: [NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 14.0)!]) // Font
    placeHolder.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: location, length: lenght))
    textFieldName?.attributedPlaceholder = placeHolder
}

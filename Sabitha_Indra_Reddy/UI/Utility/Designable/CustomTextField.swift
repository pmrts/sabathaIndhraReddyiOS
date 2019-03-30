//
//  CustomTextField.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 11/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    override func draw(_ rect: CGRect) {
        // Drawing code

        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.black.cgColor
        self.layer.addSublayer(bottomBorder)
    }
 

}

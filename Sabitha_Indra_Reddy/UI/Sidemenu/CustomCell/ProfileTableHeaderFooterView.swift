//
//  ProfileTableHeaderFooterView.swift
//  DKS
//
//  Created by Aditya Bonthu on 13/03/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class ProfileTableHeaderFooterView: UITableViewHeaderFooterView {
    class var identifier: String { return String.className(self) }

    @IBOutlet var profileBackView: UIView?
    @IBOutlet var profileImageView: UIImageView?
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
       // profileBackView?.applyGradient(colours: [Colors.DrakBlue, Colors.NavyBlue])
        profileImageView?.layer.cornerRadius = (profileImageView?.frame.height)! / 2.0
        self.profileBackView?.applyGradient(colours: [Colors.DeepSaffron, Colors.normalWhite, Colors.IndiaGreen])
    }
    

}

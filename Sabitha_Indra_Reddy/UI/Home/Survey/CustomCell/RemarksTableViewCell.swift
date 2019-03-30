//
//  RemarksTableViewCell.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 17/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class RemarksTableViewCell: UITableViewHeaderFooterView {
    class var identifier: String { return String.className(self) }
    
    @IBOutlet var remarksTextView: UITextView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

}

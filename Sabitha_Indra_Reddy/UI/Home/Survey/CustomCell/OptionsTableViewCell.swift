//
//  OptionsTableViewCell.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 09/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }

    @IBOutlet var backView: UIView?
    @IBOutlet var optionLabel: UILabel?
    @IBOutlet var optionButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView?.layer.borderWidth = 1.0
        backView?.layer.cornerRadius = (backView?.frame.height)! / 2
        backView?.layer.borderColor = Colors.IndiaGreen.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cellSelected() {
        let isSelected = optionButton?.isSelected ?? false
        optionButton?.isSelected = !isSelected
    }

}

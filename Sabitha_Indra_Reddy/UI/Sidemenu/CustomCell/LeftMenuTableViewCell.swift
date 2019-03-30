//
//  LeftMenuTableViewCell.swift
//  DKS
//
//  Created by Aditya Bonthu on 02/03/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit


class LeftMenuTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    @IBOutlet var menuImageView: UIImageView?
    @IBOutlet var menuTitleLabel: UILabel?
    @IBOutlet var arrowImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

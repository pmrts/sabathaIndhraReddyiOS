//
//  TeamRajTableViewCell.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 17/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class TeamRajTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }

    @IBOutlet var backView: UIView?
    @IBOutlet var teamimageView: UIImageView?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var desginationLabel: UILabel?
    @IBOutlet var emailLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView?.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

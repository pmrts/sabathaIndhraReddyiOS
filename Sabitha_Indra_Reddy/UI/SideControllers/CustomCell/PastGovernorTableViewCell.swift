//
//  PastGovernorTableViewCell.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 17/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class PastGovernorTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    @IBOutlet var govimageView: UIImageView?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var yearLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

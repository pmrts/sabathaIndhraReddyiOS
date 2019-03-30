//
//  CongressVideoTableViewCell.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 11/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class CongressVideoTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }

    @IBOutlet var videoDateLabel: UILabel?
    @IBOutlet var videoImageView: UIImageView?
    @IBOutlet var videoHeadLabel: UILabel?
    @IBOutlet var videoMatterLabel: UILabel?
    @IBOutlet var videoExpandView: UIImageView?
    @IBOutlet var playButton : UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

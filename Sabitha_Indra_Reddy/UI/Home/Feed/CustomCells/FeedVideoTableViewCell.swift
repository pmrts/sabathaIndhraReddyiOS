//
//  FeedVideoTableViewCell.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 05/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class FeedVideoTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }

    @IBOutlet var videoBackgroundView: UIView?
    @IBOutlet var videoImageView: UIImageView?
    @IBOutlet var videoDateLabel: UILabel?
    @IBOutlet var videoTitleLabel: UILabel?
    @IBOutlet var videoDescriptionLabel: UILabel?
    @IBOutlet var videoPlayButton: UIButton?
    @IBOutlet var videoLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        videoLabel?.layer.cornerRadius = (videoLabel?.frame.height)! / 2
        videoBackgroundView?.layer.cornerRadius = 5.0
        videoBackgroundView?.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

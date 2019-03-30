//
//  FeedNewsTableViewCell.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 05/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class FeedNewsTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    @IBOutlet var newsBackgroundView: UIView?
    @IBOutlet var newsImageView: UIImageView?
    @IBOutlet var newsDateLabel: UILabel?
    @IBOutlet var newsTitleLabel: UILabel?
    @IBOutlet var newsDescriptionLabel: UILabel?
    @IBOutlet var pageControlSource: UIPageControl?
    @IBOutlet var newsLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsLabel?.layer.cornerRadius = (newsLabel?.frame.height)! / 2
        newsBackgroundView?.layer.cornerRadius = 5.0
        newsBackgroundView?.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

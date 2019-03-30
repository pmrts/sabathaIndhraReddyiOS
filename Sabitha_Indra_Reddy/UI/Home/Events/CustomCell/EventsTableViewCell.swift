//
//  EventsTableViewCell.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 12/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    @IBOutlet var eventsBackgroundView: UIView?
    @IBOutlet var eventsImageView: UIImageView?
    @IBOutlet var eventsHeadingLabel: UILabel?
    @IBOutlet var eventsTimeLabel: UILabel?
    @IBOutlet var eventsDateLabel: UILabel?
    @IBOutlet var eventsAddressLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        eventsBackgroundView?.layer.cornerRadius = 5.0
        eventsBackgroundView?.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   

}

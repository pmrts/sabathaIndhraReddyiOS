//
//  TicketTableViewCell.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 06/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {
      class var identifier: String { return String.className(self) }

    @IBOutlet var ticketBackgroundView: UIView?
    @IBOutlet var ticketTopView: UIView?
    @IBOutlet var ticketNumberLabel: UILabel?
    @IBOutlet var ticketdateLabel: UILabel?
    @IBOutlet var ticketTitleLabel: UILabel?
    @IBOutlet var ticketStatusLabel: UILabel?
    @IBOutlet var ticketDescriptionLabel: UILabel?
    @IBOutlet var ticketAssiginedLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ticketBackgroundView?.layer.cornerRadius = 5.0
        ticketStatusLabel?.layer.cornerRadius = 5.0
        ticketTopView?.roundedView()
        ticketBackgroundView?.dropShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

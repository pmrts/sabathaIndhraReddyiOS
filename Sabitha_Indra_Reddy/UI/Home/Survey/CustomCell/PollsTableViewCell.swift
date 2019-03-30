//
//  PollsTableViewCell.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 07/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class PollsTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    @IBOutlet var pollBackgroundView: UIView?
    @IBOutlet var pollTopView: UIView?
    @IBOutlet var pollNumberLabel: UILabel?
    @IBOutlet var pollDateLabel: UILabel?
    @IBOutlet var pollQuestionLabel: UILabel?
    @IBOutlet var pollProgressBarView: UIView?
    @IBOutlet var pollProgressYesView: UIView?
    @IBOutlet var pollYesButton: UIButton?
    @IBOutlet var pollNoButton: UIButton?
    @IBOutlet var pollvotedLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pollBackgroundView?.layer.cornerRadius = 5.0
        pollProgressBarView?.layer.cornerRadius = 5.0
        pollProgressYesView?.layer.cornerRadius = 5.0
        pollBackgroundView?.dropShadow()
        pollTopView?.roundedView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

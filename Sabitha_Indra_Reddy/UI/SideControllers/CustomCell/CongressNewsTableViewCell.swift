//
//  CongressNewsTableViewCell.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 11/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class CongressNewsTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }

    @IBOutlet var newsDateLabel: UILabel?
    @IBOutlet var newsImageView: UIImageView?
    @IBOutlet var newsHeadLabel: UILabel?
    @IBOutlet var newsMatterLabel: UILabel?
    @IBOutlet var newsExpandView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

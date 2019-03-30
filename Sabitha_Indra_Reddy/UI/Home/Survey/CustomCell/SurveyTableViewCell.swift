//
//  SurveyTableViewCell.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 07/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class SurveyTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }

    @IBOutlet var SurveyBackgroundView: UIView?
    @IBOutlet var SurveyTopView: UIView?
    @IBOutlet var SurveyNumberLabel: UILabel?
    @IBOutlet var SurveyDateLabel: UILabel?
    @IBOutlet var SurveyQuestionLabel: UILabel?
    @IBOutlet var SurveyvotedLabel: UILabel?
    @IBOutlet var SurveyTakeLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        SurveyBackgroundView?.layer.cornerRadius = 5.0
        SurveyTakeLabel?.layer.cornerRadius = 10.0
        SurveyBackgroundView?.dropShadow()
        SurveyTopView?.roundedView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

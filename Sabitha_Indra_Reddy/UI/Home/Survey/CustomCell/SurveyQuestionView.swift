//
//  SurveyQuestionView.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 09/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class SurveyQuestionView: UITableViewHeaderFooterView {
    class var identifier: String { return String.className(self) }
    
    @IBOutlet var questionLabel: UILabel?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

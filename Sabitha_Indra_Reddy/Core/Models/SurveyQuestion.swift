//
//  SurveyDetailData.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 14/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import Foundation

class SurveyQuestion: Codable {
    
    var question_id: String
    var question_name: String
    var options: [SurveyOptions]
}

class SurveyOptions: Codable {
    
    var option_id: String?
    var option_name: String?
    var option_value: String?
    
}


class SurveySubmit: Codable {
    
    var poll_question_id: String
    var poll_option_id: String
    var remarks: String?
    
    init(questionID: String, optionID: String, remarks: String?) {
        self.poll_question_id = questionID
        self.poll_option_id = optionID
        self.remarks = remarks
    }
    
}

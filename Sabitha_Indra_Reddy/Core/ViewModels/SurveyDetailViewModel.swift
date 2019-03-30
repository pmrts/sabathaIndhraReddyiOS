//
//  SurveyDetailViewModel.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 14/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import Foundation

class SurveyDetailViewModel {
    
    private var surveyQuestion = [SurveyQuestion]()
    
    public func fetchAllSurveyDetailData(suveryid: String, completionCallback: @escaping (Bool,Error?) -> Void) {
        SabithaNetworkAdapter.request(target: .surveyDetailData(surveyid: suveryid), success: { (response) in
            do {
                let jsonData = try response["result"].rawData()
                
                let detaillist = try JSONDecoder().decode([SurveyQuestion].self, from: jsonData)
            
                self.surveyQuestion.append(contentsOf: detaillist)
                completionCallback(true,nil)
            } catch {
                completionCallback(false,error)
            }
        }, error: { (error) in
            print(error.localizedDescription)
        }) { (error) in
            print(error)
        }
    }
    
    public func numberOfQuestions() -> Int {
        return surveyQuestion.count
    }
    
    public func questionAtIndex(index: Int) -> SurveyQuestion {
        return surveyQuestion[index]
    }
    
    public func numberOfOptionsFor(survey: SurveyQuestion) -> Int {
        return survey.options.count
    }
    
    public func optionAtIndexFor(survey: SurveyQuestion, index: Int) -> SurveyOptions? {
        return survey.options[index]
    }
    
}

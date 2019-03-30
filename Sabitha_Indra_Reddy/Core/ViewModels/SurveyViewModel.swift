//
//  PollViewModel.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 02/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import Foundation
import UIKit

class SurveyViewModel {
    
    var pollData = [SurveyData]()
    
    public func fetchAllPollData(page: Int, completionCallback: @escaping (Bool,Error?) -> Void, completionStatus: @escaping (_ message: String) -> Void) {
        SabithaNetworkAdapter.request(target: .surveyData(page: page), success: { (response) in
            do {
                let jsonData = try response["result"].rawData()
                let polllist = try JSONDecoder().decode([SurveyData].self, from: jsonData)
                self.pollData.append(contentsOf: polllist)
                completionCallback(true,nil)
            } catch {
                completionCallback(false,error)
            }
        }, error: { (error) in
            print(error.localizedDescription)
            completionStatus("No Data Found")
        }) { (error) in
            print(error)
        }
    }
    
    public func numberOfSurveyQuestions() -> Int {
        return pollData.count
    }
    
    public func surveyQuestionAtIndex(index: IndexPath) -> SurveyData {
        return pollData[index.row]
    }    
}

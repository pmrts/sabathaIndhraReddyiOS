//
//  User.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 29/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import Foundation
import SVProgressHUD

class User: NSObject
{
    var imageBasePath = String()
    var deviceToken = String()
    var language = Int()
    var surveyID = String()
    var pushType = String()
    var surveyAnswers = [String]()
    
    static let sharedInstance: User = {
        let instance = User()
        
        return instance
    }()
}

// Functions
func getVideoCodeFromLink(urlLink: String) -> String? {
    let vCode = getQueryStringParameter(url: urlLink, param: "v")
    return vCode
}

func getQueryStringParameter(url: String, param: String) -> String? {
    guard let url = URLComponents(string: url) else { return nil }
    return url.queryItems?.first(where: { $0.name == param })?.value
}

// Method for Spinner

func showSVProgressHUD() {
    SVProgressHUD.show()
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
}

func validate(value: String) -> Bool {
    let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}

func isValidEmail(entertedStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: entertedStr)
}

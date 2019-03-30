//
//  SabithaUserDefaults.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 02/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import Foundation

class SabithaUserDefaults {
    
    static var isLoggedIn : Bool {
        return !loggedInUserID.isEmpty && !loggedInToken.isEmpty
    }
    
    static func saveLoggedInUser(user: String, token: String, username: String, usermail: String) {
        UserDefaults.standard.set(user, forKey: "userid")
        UserDefaults.standard.set(token, forKey: "Token")
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(usermail, forKey: "usermail")
    }
    
    static func saveLoggedOTP(cameForOTP: String) {
        UserDefaults.standard.set(cameForOTP, forKey: "cameOTP")
    }
    
    static func clearSavedDetails() {
        UserDefaults.standard.removeObject(forKey: "userid")
        UserDefaults.standard.removeObject(forKey: "Token")
    }

    static var loggedInUserID : String {
        guard let userid = UserDefaults.standard.string(forKey: "userid") else {
            return ""
        }
        return userid
    }
    
    static var loggedInToken : String {
        guard let token = UserDefaults.standard.string(forKey: "Token") else {
            return ""
        }
        return token
    }
    
    static var loggedInName : String {
        guard let name = UserDefaults.standard.string(forKey: "username") else {
            return ""
        }
        return name
    }
    
    static var loggedInMail : String {
        guard let mail = UserDefaults.standard.string(forKey: "usermail") else {
            return ""
        }
        return mail
    }
    
    static var saveCameScreen : String {
        guard let usercame = UserDefaults.standard.string(forKey: "cameOTP") else {
            return ""
        }
        return usercame
    }
    
}

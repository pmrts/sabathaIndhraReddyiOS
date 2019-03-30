//
//  Notifications.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 03/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    static let connectionTitle = "No Network Connection!"
    static let connectionMessage = "Please Check your Connection"
    static let connectionString = "No Connection"
    
    static let updateProfile = "Please update your profile"
}

extension Notification.Name {
    public static let KeyboardShow = UIResponder.keyboardWillShowNotification
    public static let KeyboardHide = UIResponder.keyboardWillHideNotification
    public static let LanguageChanged = Notification.Name(rawValue:"LanguageChanged")
    public static let RefreshSurvey = Notification.Name(rawValue: "RefreshSurvey")
}

public func postNotification(_ noti:Notification.Name,object: Any? = nil) {
    NotificationCenter.default.post(name: noti, object: object)
}

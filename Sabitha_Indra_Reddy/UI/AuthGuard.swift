//
//  AuthGuard.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 15/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class AuthGuard {
    
    class func showAuthenticationIfRequired() {
        if !SabithaUserDefaults.isLoggedIn {
            showAuthentication()
        } else {
            showDashboard()
        }
    }
        
        //Show Authentication
        class func showAuthentication() {
            let storyboard = UIStoryboard(name:"Authentication", bundle:nil)
            (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = storyboard.instantiateInitialViewController()
            (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
        }
        
        //Show Dashboard
        class func showDashboard() {
            let storyboard = UIStoryboard(name:"Main", bundle:nil)
            let containerViewController = storyboard.instantiateViewController(withIdentifier: "TabViewController") as! TabViewController
            (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = containerViewController
            (UIApplication.shared.delegate as? AppDelegate)?.window?.makeKeyAndVisible()
        }
    
}

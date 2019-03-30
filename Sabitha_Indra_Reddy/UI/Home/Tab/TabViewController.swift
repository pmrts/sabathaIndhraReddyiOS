//
//  TabViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 07/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if LTUserDefaults.isLoggedIn && LTUserDefaults.saveCameScreen == "1" {
//            self.selectedIndex = 2
//            LTUserDefaults.saveLoggedOTP(cameForOTP: "0")
//        } else {
//
//        }
        
        if User.sharedInstance.pushType == "3" {
            self.selectedIndex = 3
            User.sharedInstance.pushType = "0"
        } else if User.sharedInstance.pushType == "2" {
            self.selectedIndex = 2
            User.sharedInstance.pushType = "0"
        } else if User.sharedInstance.pushType == "1" {
            self.selectedIndex = 0
            User.sharedInstance.pushType = "0"
        } else {
            self.selectedIndex = 0
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

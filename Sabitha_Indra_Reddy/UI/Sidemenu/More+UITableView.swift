//
//  More+UITableView.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 27/08/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

extension MoreViewController: UITableViewDataSource, UITableViewDelegate {

    // Table View Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftMenuTableViewCell.identifier)
        if let Cell = cell as? LeftMenuTableViewCell {
            Cell.menuTitleLabel?.text = menuNameArray[indexPath.row]
            Cell.menuImageView?.image = menuImageArray[indexPath.row]
            Cell.selectionStyle = .none
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 175.0
        } else {
            return 0.1
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProfileTableHeaderFooterView.identifier) as? ProfileTableHeaderFooterView
 
          //  let profileImageTap = UITapGestureRecognizer (target: self, action: #selector(tappedProfileImage(_:)))
         //   cell?.profileImageView?.addGestureRecognizer(profileImageTap)
          //  cell?.profileBackView?.backgroundColor = Colors.IndiaGreen
            
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            gotoViewController(identifier: "AboutViewController")
        } else if indexPath.row == 1 {
            gotoViewController(identifier: "EnrolViewController")
        } else if indexPath.row == 2 {
            gotoViewController(identifier: "IdeasViewController")
        } else if indexPath.row == 3 {
            gotoViewController(identifier: "CongressViewController")
        } else if indexPath.row == 4 {
            gotoViewController(identifier: "PollingBoothViewController")
        } else if indexPath.row == 5 {
            gotoViewController(identifier: "VolunteerViewController")
        } else if indexPath.row == 6 {
            gotoViewController(identifier: "SocialConnectViewController")
        } else if indexPath.row == 7 {
            gotoViewController(identifier: "ProfileViewController")
        } else if indexPath.row == 8 {
            shareAPP()
        } else if indexPath.row == 9 {
            performLogout()
        }
        
    }
    
    func shareAPP() {
        let text = "https://itunes.apple.com/in/app/sabitha-indra-reddy/id1442085648?mt=8" // text to share
        
        // set up activity view controller
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func gotoViewController(identifier: String) {
        let storyboard = UIStoryboard(name:"SideControl", bundle:nil)
        let VC = storyboard.instantiateViewController(withIdentifier: identifier)
        self.navigationItem.backBarButtonItem = UIBarButtonItem (title: "", style: .done, target: nil, action: nil)
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    @objc func profileButtonAction() {
        
    }
    
    func performLogout() {
        let alert = UIAlertController (title: "Logout", message: "Are you sure", preferredStyle: .alert)
        let okaction = UIAlertAction (title: "OK", style: .default, handler: { (action) in
            SabithaUserDefaults.clearSavedDetails()
            AuthGuard.showAuthentication()
        })
        let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: { (action) in
            
        })
        alert.addAction(okaction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}

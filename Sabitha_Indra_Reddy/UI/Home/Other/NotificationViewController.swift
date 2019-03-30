//
//  NotificationViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 17/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationViewController: UIViewController {

    var notijson: JSON = JSON.null
    @IBOutlet var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem (title: "", style: .done, target: nil, action: nil) // Hide Back Button
        getNotifications()
        // Do any additional setup after loading the view.
    }

    func getNotifications() {
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .notifications(), success: { (response) in
                print(response)
                self.notijson = JSON(response)
            }, error: { (error) in
                print(error.localizedDescription)
                self.handleError(error)
            }) { (error) in
                print(error)
            }
        } else {
            
        }
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

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.detailTextLabel?.text = self.notijson["message"][indexPath.row]["notification_description"].stringValue
        cell.textLabel?.text = self.notijson["message"][indexPath.row]["notification_title"].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}

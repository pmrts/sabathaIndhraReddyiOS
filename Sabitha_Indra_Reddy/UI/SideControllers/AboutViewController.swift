//
//  AboutViewController.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 17/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var matterLabel: UILabel?
    
    var matterStr = "<p>Patlolla Sabitha Indra Reddy is an Indian politician and the first woman Home Minister of Andhra Pradesh (INC). Earlier, she was a member of Chief Minister Y. S. Rajasekhara Reddys cabinet.</p><p>Sabitha was born on 5 May 1963 at Tandur to G. Mahipal Reddy. She completed her education in B.Sc and has been a Member of the Legislative Assembly of Andhra Pradesh for two terms from Rajendra Nagar assembly constituency (2004 - 2009) and Maheshwaram constituency (2009 - 2014).</p><p>She was married to P. Indra Reddy (1954-2000) who was the Home Minister in N. T. Rama Rao's Cabinet and has three sons (Karthik, Koushik & Kalyan).</p><p>Sabitha held the position of Mines and Geology Minister in the earlier government (2004 - 2009).</p><p>Presently She is a Vice President TPCC (Telangana Pradesh Congress Committe) and she is Constesting as a Congress MLA Conditate from Maheshwaram constituency for the year 2018.</p>"

    override func viewDidLoad() {
        super.viewDidLoad()

      //  matterLabel?.setHTMLFromString(htmlText: matterStr)
        getaboutUS()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getaboutUS() {
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .aboutLTGovernor(), success: { (response) in
                print(response)
                let matter = response["result"][0]["about_desc"].stringValue
                self.matterLabel?.setHTMLFromString(htmlText: matter)
                self.imageView?.imageFromServerURL(urlString: response["result"][0]["about_image"].stringValue)
            }, error: { (error) in
                print(error.localizedDescription)
                self.handleError(error)
            }) { (error) in
                print(error)
            }
        } else {
            
        }
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

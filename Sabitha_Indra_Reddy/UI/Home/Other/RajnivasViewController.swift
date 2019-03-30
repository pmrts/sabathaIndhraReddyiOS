//
//  RajnivasViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 08/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class RajnivasViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // 1 to desired number of seconds
            // Your code with delay
            self.performSegue(withIdentifier: "splashImageSegue", sender: self)
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

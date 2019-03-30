//
//  PollingBoothViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 14/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class PollingBoothViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        if let url = URL(string: "https://electoralsearch.in/") {
             webView.load(URLRequest(url: url))
        }
       
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        showSVProgressHUD()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        SVProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

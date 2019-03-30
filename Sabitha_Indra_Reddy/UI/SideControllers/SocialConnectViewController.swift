//
//  SocialConnectViewController.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 10/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class SocialConnectViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var collectionView: UICollectionView?
    
    var socailArray = ["Facebook", "Twitter", "Youtube", "Instagram"]
    var imageArray = [UIImage (named: "Facebook"), UIImage (named: "Twitter"), UIImage (named: "Youtube"), UIImage (named: "Instagram")]
    var selectedSocial = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        if let collection = collectionView {
            configure(collectionView: collection)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewLoadURL(LinkURL: String) {
        if let LURL = URL (string: LinkURL) {
            webView?.load(URLRequest (url: LURL))
        }
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

}

extension SocialConnectViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    internal func configure(collectionView: UICollectionView) {
        collectionView.registerReusableCell(SocialConnectCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socailArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = SocialConnectCollectionViewCell.dequeue(fromCollectionView: collectionView, atIndexPath: indexPath)
        cell.socialNameLabel?.text = socailArray[indexPath.row]
        webViewLoadURL(LinkURL: "https://www.facebook.com/SabithaIndraReddyOfficial/")

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedSocial = indexPath.item
        switch selectedSocial {
        case 0:
            webViewLoadURL(LinkURL: "https://www.facebook.com/SabithaIndraReddyOfficial/")
        case 1:
            webViewLoadURL(LinkURL: "https://twitter.com/sabithaindrare1")
        case 2:
            webViewLoadURL(LinkURL: "https://www.youtube.com/channel/UCrlli0WqTtiaE5v7LIEKbNA")
        case 3:
            webViewLoadURL(LinkURL: "https://www.instagram.com/sabithaindrareddypatlolla/")
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130.0, height: 40.0)
    }
    
}

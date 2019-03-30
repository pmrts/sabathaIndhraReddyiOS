//
//  FeedDetailViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 30/08/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import XCDYouTubeKit

class FeedDetailViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var detailImageView: UIImageView?
    @IBOutlet var detailTitleLabel: UILabel?
    @IBOutlet var detailDescLabel: UILabel?
    @IBOutlet var detailDateLabel: UILabel?
    @IBOutlet var detailPlayButton: UIButton?
    
    @IBOutlet var backwardButton: UIButton?
    @IBOutlet var forwardButton: UIButton?
    
    var feeddata = FeedData()
    var index : NSInteger = 0
    var count = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if feeddata.feed_type == "1" {
            self.navigationItem.title = "Videos"
            detailPlayButton?.isHidden = false
            forwardButton?.isHidden = true
            backwardButton?.isHidden = true
        } else {
            self.navigationItem.title = "News"
            detailPlayButton?.isHidden = true
            forwardButton?.isHidden = false
            backwardButton?.isHidden = false
        }
        
        detailTitleLabel?.text = feeddata.feed_name
        detailDescLabel?.setHTMLFromString(htmlText: feeddata.feed_desc!)
        detailDateLabel?.text = feeddata.feed_date
        if feeddata.feed_type == "1" {
            let videoCode = getVideoCodeFromLink(urlLink:feeddata.feed_videolink!)
            let urlString = String (format: "http://img.youtube.com/vi/%@/mqdefault.jpg", videoCode!)
            detailImageView?.imageFromServerURL(urlString: urlString)
        } else {
            detailImageView?.imageFromServerURL(urlString: feeddata.feed_images![0].image_name!)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if feeddata.feed_type == "2" && feeddata.feed_images!.count > 1 {
            forwardButton?.isHidden = false
            backwardButton?.isHidden = false
            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(ChangeImageTimer), userInfo: nil, repeats: true)
        } else {
            forwardButton?.isHidden = true
            backwardButton?.isHidden = true
        }
    }
    
    func playVideo(videoIdentifier: String?) {
        let playerViewController = AVPlayerViewController()
        self.present(playerViewController, animated: true, completion: nil)
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoIdentifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
            if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
                playerViewController?.player = AVPlayer(url: streamURL)
                playerViewController?.player?.play()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        let videoCode = getVideoCodeFromLink(urlLink: feeddata.feed_videolink!)
        self.playVideo(videoIdentifier: videoCode)
    }
    
    @IBAction func forwordButtonAction(_ sender: UIButton) {
        if (index < feeddata.feed_images!.count-1) {
            backwardButton?.isHidden = false
            index += 1
            let trimmedString = feeddata.feed_images![index].image_name!.trimmingCharacters(in: .whitespaces)
            self.detailImageView?.imageFromServerURL(urlString: trimmedString)
        }
        
        if index == count - 1 {
            forwardButton?.isHidden = true
        }
    }
    
    @IBAction func backwardButtonAction(_ sender: UIButton) {
        if (index > 0) {
            forwardButton?.isHidden = false
            backwardButton?.isHidden = true
            index -= 1
            let trimmedString = feeddata.feed_images![index].image_name!.trimmingCharacters(in: .whitespaces)
            self.detailImageView?.imageFromServerURL(urlString: trimmedString)
        }
    }
    
    @IBAction func shareButtonAction(_ sender: UIButton) {
        let text = "" // text to share
        
        // set up activity view controller
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }

    @objc func ChangeImageTimer(_ timer : Timer) {
        if index == count - 1 {
            index = 0
            self.detailImageView?.imageFromServerURL(urlString: feeddata.feed_images![0].image_name!)
            backwardButton?.isHidden = true
            forwardButton?.isHidden = false
        }
        else {
            if (index < feeddata.feed_images!.count-1) {
                backwardButton?.isHidden = false
                index += 1
                let trimmedString = feeddata.feed_images![index].image_name!.trimmingCharacters(in: .whitespaces)
                self.detailImageView?.imageFromServerURL(urlString: trimmedString)
                
                if index == count - 1 {
                    forwardButton?.isHidden = true
                }
            }
            else
            {}
        }
    }
    
}

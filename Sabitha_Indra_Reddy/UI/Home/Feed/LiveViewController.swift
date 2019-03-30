//
//  LiveViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 19/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import AVKit
import XCDYouTubeKit

class LiveViewController: UIViewController {

    @IBOutlet var noLiveLabel: UILabel?
    @IBOutlet var thumblineImageView: UIImageView?
    @IBOutlet var playButton: UIButton?
    
    var videoCode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noLiveLabel?.isHidden = true
        playButton?.isHidden = true
        thumblineImageView?.isHidden = true
        liveStreaming()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playButtonAction(_ sender : UIButton) {
        self.playVideo(videoIdentifier: videoCode)
    }
    
    func liveStreaming() {
        if ReachabilityManager.shared.isNetworkAvailable == false {
            SabithaNetworkAdapter.request(target: .liveStreaming(), success: { (response) in
                print(response)
                if response["status"] == 1 {
                    self.thumblineImageView?.isHidden = false
                    self.playButton?.isHidden = false
                    let videoURL = response["liveStreams"]["type_name"].stringValue
                    if let getvCode = getVideoCodeFromLink(urlLink: videoURL) {
                        self.videoCode = getvCode
                    }
                    let urlString = String (format: "http://img.youtube.com/vi/%@/mqdefault.jpg", self.videoCode)
                    self.thumblineImageView?.af_setImage(withURL: URL (string: urlString)!, placeholderImage: UIImage (named: "imageholder"))
                } else {
                    self.noLiveLabel?.isHidden = false
                }
            }, error: { (error) in
                self.noLiveLabel?.isHidden = false
                self.handleError(error)
                print(error.localizedDescription)
            }) { (error) in
                print(error)
            }
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK") { (action) in
                
            }
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

}

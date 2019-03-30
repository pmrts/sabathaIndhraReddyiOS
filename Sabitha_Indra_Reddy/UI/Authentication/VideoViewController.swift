//
//  VideoViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 13/11/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import YouTubePlayer

class VideoViewController: UIViewController, YouTubePlayerDelegate {
    
    @IBOutlet var videoView: YouTubePlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        videoView.delegate = self
        videoView.loadVideoID("qJMeJahP5Is")
        
        videoView.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "modestbranding": "1",
            "showinfo": "0",
            "loop": "0",
            "rel": "0"
            ] as [String: AnyObject]
        
        videoView.play()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func skipButtonAction(_ sender: UIButton) {
        videoView.pause()
        self.performSegue(withIdentifier: "splashVideoSegue", sender: self)
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        if playerState == .Ended {
            videoView.stop()
            self.performSegue(withIdentifier: "splashVideoSegue", sender: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

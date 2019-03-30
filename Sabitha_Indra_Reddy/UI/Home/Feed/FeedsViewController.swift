//
//  FeedsViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 05/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import XCDYouTubeKit
import AlamofireImage
import SwiftyJSON

struct YouTubeVideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
}

class FeedsViewController: UIViewController {

    @IBOutlet var topView: UIView?
    @IBOutlet var tableView: UITableView?
    
    var feedViewModel = FeedViewModel()
    var pageCount: Int = 1
    var videoCode = String()
    var colorView = UIView()
    var selectedOption : Int = 0
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        pageCount = 1
        refreshControl.addTarget(self, action:#selector(handleRefresh), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.darkGray
        return refreshControl
    }()
    
    var feedjson: JSON = JSON.null
    var deviceID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceID = UIDevice.current.identifierForVendor!.uuidString    // UUID
        
        self.tableView?.registerCellNib(FeedNewsTableViewCell.self)
        self.tableView?.registerCellNib(FeedVideoTableViewCell.self)
        
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Colors.DeepSaffron, Colors.normalWhite, Colors.IndiaGreen])
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem (title: "", style: .done, target: nil, action: nil) // Hide Back Button
        self.tableView?.addSubview(refreshControl)
        fetchFeedDataandReload()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchFeedDataandReload() {
        if Reachability()?.currentReachabilityString != "No Connection" {
            feedViewModel.fetchAllFeedData(page: self.pageCount, completionCallback: { (isSuccess, error) in
                if isSuccess {
                    self.sendDeviceToken()
                    self.tableView?.reloadData()
                } else if let someError = error {
                    print(someError.localizedDescription)
                    self.handleError(someError)
                }
            })
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
    }
    
    func sendDeviceToken() {
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .deviceTokenRegister(deviceToken: User.sharedInstance.deviceToken, deviceID: deviceID, deviceType: "1"), success: { (response) in
                print(response)
                self.validateUser() 
            }, error: { (error) in
                print(error)
            }) { (error) in
                print(error)
            }
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
    }
    
    func validateUser() {
        if Reachability()?.currentReachabilityString != "No Connection" {
            SabithaNetworkAdapter.request(target: .ValidateUser(), success: { (response) in
                print(response)
            }, error: { (error) in
                print(error.localizedDescription)
                self.logoutUser()
            }, failure: { (error) in
                print(error)
            })
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
    }
    
    func logoutUser() {
        alertController(title: nil, message: "Your Account is not Active. Please Login again", actionTitle: "OK") { (action) in
            SabithaUserDefaults.clearSavedDetails()
            AuthGuard.showAuthentication()
        }
    }
    
    @objc func handleRefresh() {
      //  feedViewModel.removeAll()
        fetchFeedDataandReload()
        refreshControl.endRefreshing()
    }
    
    @objc func playButtonPressed(_ sender: UIButton) {
        let button = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView) // Getting the location of the button tapped
        let indexPath = self.tableView?.indexPathForRow(at: button)  // Knowing indexPath for that button
        if let index = indexPath {
            let data = feedViewModel.newsItemAtIndex(index: index)
            if let vLink = data.feed_videolink {
                let videoCode = getVideoCodeFromLink(urlLink: vLink)
                self.playVideo(videoIdentifier: videoCode)
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
    
    @IBAction func callBarButtonAction(_ sender: UIBarButtonItem) {
     //   UIApplication.shared.open(URL(string: "tel://9500560001")!, options: [:], completionHandler: nil)
        self.performSegue(withIdentifier: "notifiSegue", sender: self)
        
    }
    
    @IBAction func liveBarButtonAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "liveSegue", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedDetailSegue" {
            if let index = self.tableView?.indexPathForSelectedRow {
                let data = feedViewModel.newsItemAtIndex(index: index)
                let feedDetailVC = segue.destination as! FeedDetailViewController
                feedDetailVC.feeddata = data
            }
        }
    }
}

// MARK : - UITable View Methods 

extension FeedsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.numberOfNewsItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let data = feedViewModel.newsItemAtIndex(index: indexPath)
        if data.feed_type == "1" {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedVideoTableViewCell.identifier, for: indexPath)
            if let videoCell = cell as? FeedVideoTableViewCell, let vLink = data.feed_videolink, let getvCode = getVideoCodeFromLink(urlLink: vLink), let desc = data.feed_desc {
                videoCell.videoBackgroundView?.backgroundColor = UIColor.white
                videoCell.videoTitleLabel?.text = data.feed_name
                videoCell.videoDescriptionLabel?.setHTMLFromString(htmlText: desc)
                videoCell.videoDateLabel?.changeDateFormat(date: data.feed_date, format: "dd-MM-yyyy", toChangeFormat: "dd MMM, yyyy")
                videoCell.videoPlayButton?.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
                videoCode = getvCode
                let urlString = String (format: "http://img.youtube.com/vi/%@/mqdefault.jpg", videoCode)
                if let videothumbnail = URL(string: urlString) {
                    videoCell.videoImageView?.af_setImage(withURL: videothumbnail, placeholderImage: UIImage (named: "imageholder"))
                }
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedNewsTableViewCell.identifier, for: indexPath)
            if let newsCell = cell as? FeedNewsTableViewCell, let images = data.feed_images, let desc = data.feed_desc, let urlStrImage = images[0].image_name, let imageURL = URL(string: urlStrImage) {
                newsCell.newsTitleLabel?.text = data.feed_name
                newsCell.newsDescriptionLabel?.setHTMLFromString(htmlText: desc)
                newsCell.newsDateLabel?.changeDateFormat(date: data.feed_date, format: "dd-MM-yyyy", toChangeFormat: "dd MMM, yyyy")
                newsCell.newsBackgroundView?.backgroundColor = UIColor.white
                newsCell.newsImageView?.af_setImage(withURL: imageURL, placeholderImage: UIImage (named: "imageholder"))
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "feedDetailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height-500)) {
            pageCount += 1
            fetchFeedDataandReload()
        }
    }
}

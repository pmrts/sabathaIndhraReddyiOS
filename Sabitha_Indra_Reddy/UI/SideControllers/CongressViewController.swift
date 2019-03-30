//
//  CongressViewController.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 14/09/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import SwiftyJSON
import XCDYouTubeKit
import SVProgressHUD
import AVKit

private let collectionReuseIdentifier = "CommomCollectionViewCell"
private let newsReuseIdentifier = "CongressNewsTableViewCell"
private let videoReuseIdentifier = "CongressVideoTableViewCell"

class CongressViewController: UIViewController {

    var incjson: JSON = JSON.null
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet var tableView: UITableView?
    
    var selectedYear = Int()
    var selectedCellIndexPath: IndexPath?
    var imageURL = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView?.register(UINib (nibName: "CongressNewsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: newsReuseIdentifier)
        self.tableView?.register(UINib (nibName: "CongressVideoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: videoReuseIdentifier)
        self.collectionView?.register(UINib (nibName: "CommomCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: collectionReuseIdentifier)
        INCStaticAPICalling()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func INCStaticAPICalling() {
        if ReachabilityManager.shared.isNetworkAvailable == false {
            showSVProgressHUD()
            DispatchQueue.global(qos:.userInitiated).async
                {
                    let urlString = String(format:"https://s3.ap-south-1.amazonaws.com/elasticbeanstalk-ap-south-1-604424016609/JSON_Static_files/INC.json")                    // API URL
                    var request = URLRequest(url: URL(string:urlString)!)   // Creating Request
                    request.httpMethod = "GET"
                    // Creating Session
                    URLSession.shared.dataTask(with:request) { (data, response, error) in
                        if error != nil {
                            print("error is ",error!)
                        }
                        else {
                            self.incjson = JSON(data!)
                            OperationQueue.main.addOperation {
                                self.collectionView?.reloadData()
                                self.tableView?.reloadData()
                                SVProgressHUD.dismiss()
                            }
                        }
                        }.resume()
            }
        } else {
            alertController(title: "No Network Connection!", message: "Please Check Your Connection", actionTitle: "OK") { (action) in
                
            }
        }
    }
    
    @objc func playButtonPressed(_ sender: UIButton) {
        let button = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView) // Getting the location of the button tapped
        let indexPath = self.tableView?.indexPathForRow(at: button)  // Knowing indexPath for that button
        if let index = indexPath?.row {
            let videoCode = self.incjson["data"][selectedYear]["List"][index]["URL"].stringValue
            self.playVideo(videoIdentifier: videoCode)
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

    @objc func tapImagePressed(_ gesture: UITapGestureRecognizer) {
        let taplocation = gesture.location(in: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: taplocation)  // Knowing indexPath for that button
        let feedtype = self.incjson["data"][selectedYear]["List"][(indexPath?.row)!]["feedtype"].stringValue
        
        if feedtype == "1" {
            imageURL = self.incjson["data"][selectedYear]["List"][(indexPath?.row)!]["URL"].stringValue
            self.performSegue(withIdentifier: "showImageSegue", sender: nil)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageSegue" {
            let showVC = segue.destination as! ImageZoomViewController
            showVC.ImageURL = imageURL
        }
    }

}

// MARK : - ***** Collection View Methods *****

extension CongressViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.incjson["data"].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionReuseIdentifier, for: indexPath)
        if let Cell = cell as? CommomCollectionViewCell {
            Cell.commonLabel?.text = self.incjson["data"][indexPath.item]["MainYear"].stringValue
            
            if selectedYear == indexPath.item {
                Cell.setSelected = true
            } else {
                Cell.setSelected = false
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedYear = indexPath.item
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        collectionView.reloadData()
        
        DispatchQueue.main.async {
            let topPath = IndexPath(row: 0, section: 0)
            self.tableView?.scrollToRow(at: topPath, at: .top, animated: true)
        }
        self.tableView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: collectionView.bounds.height)
    }
}

// MARK : - ***** Table View Methods *****

extension CongressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.incjson["data"][selectedYear]["List"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedtype = self.incjson["data"][selectedYear]["List"][indexPath.row]["feedtype"].stringValue
        
        if feedtype == "1" {
            let cell = tableView.dequeueReusableCell(withIdentifier: newsReuseIdentifier, for: indexPath)
            if let Cell = cell as? CongressNewsTableViewCell {
                Cell.newsDateLabel?.text = self.incjson["data"][selectedYear]["List"][indexPath.row]["Year"].stringValue
                Cell.newsHeadLabel?.text = self.incjson["data"][selectedYear]["List"][indexPath.row]["Headline"].stringValue
                Cell.newsMatterLabel?.text = self.incjson["data"][selectedYear]["List"][indexPath.row]["Matter"].stringValue
                
                let imageTap = UITapGestureRecognizer (target: self, action: #selector(tapImagePressed))
                Cell.newsImageView?.addGestureRecognizer(imageTap)
                let imageurl = self.incjson["data"][selectedYear]["List"][indexPath.row]["URL"].stringValue
                Cell.newsImageView?.af_setImage(withURL: URL(string: imageurl)!, placeholderImage: UIImage (named: "imageholder"))
                Cell.newsExpandView?.transform = CGAffineTransform.identity
                if let labelWidth = Cell.newsMatterLabel?.frame.size.width, (Cell.newsMatterLabel?.textHeight(withWidth: labelWidth))! > CGFloat(95) {
                    Cell.newsExpandView?.isHidden = false
                    if let selectedIndex = selectedCellIndexPath, indexPath == selectedIndex {
                        Cell.newsExpandView?.isHighlighted = true
                        Cell.newsMatterLabel?.numberOfLines = 0
                    } else {
                        Cell.newsExpandView?.isHighlighted = false
                        Cell.newsMatterLabel?.numberOfLines = 5
                    }
                } else {
                    Cell.newsExpandView?.isHidden = true
                }
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: videoReuseIdentifier, for: indexPath)
            if let Cell = cell as? CongressVideoTableViewCell {
                
                Cell.videoDateLabel?.text = self.incjson["data"][selectedYear]["List"][indexPath.row]["Year"].stringValue
                Cell.videoHeadLabel?.text = self.incjson["data"][selectedYear]["List"][indexPath.row]["Headline"].stringValue
                Cell.videoMatterLabel?.text = self.incjson["data"][selectedYear]["List"][indexPath.row]["Matter"].stringValue
                
                let videoURL = self.incjson["data"][selectedYear]["List"][indexPath.row]["URL"].stringValue
                let urlString = String (format: "http://img.youtube.com/vi/%@/mqdefault.jpg", videoURL)
                Cell.videoImageView?.af_setImage(withURL: URL(string: urlString)!, placeholderImage: UIImage (named: "imageholder"))
                Cell.playButton?.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
                Cell.videoExpandView?.transform = CGAffineTransform.identity
                if let labelWidth = Cell.videoMatterLabel?.frame.size.width, (Cell.videoMatterLabel?.textHeight(withWidth: labelWidth))! > CGFloat(95) {
                    Cell.videoExpandView?.isHidden = false
                    if let selectedIndex = selectedCellIndexPath, indexPath == selectedIndex {
                        Cell.videoExpandView?.isHighlighted = true
                        Cell.videoMatterLabel?.numberOfLines = 0
                    } else {
                        Cell.videoExpandView?.isHighlighted = false
                        Cell.videoMatterLabel?.numberOfLines = 5
                    }
                } else {
                    Cell.videoExpandView?.isHidden = true
                }
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndex = selectedCellIndexPath, selectedIndex == indexPath {
            selectedCellIndexPath = nil
        } else {
            selectedCellIndexPath = indexPath
        }
        tableView.reloadData()
        
        if selectedCellIndexPath != nil {
            // This ensures, that the cell is fully visible once expanded
            //tableView.scrollToRow(at: indexPath, at: .none, animated: true)
        }
    }
}


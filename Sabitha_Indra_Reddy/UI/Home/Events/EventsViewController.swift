//
//  EventsViewController.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 05/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventsViewController: UIViewController {

    var eventjson: JSON = JSON.null
    @IBOutlet var tableView: UITableView?
    @IBOutlet var topView: UIView?
    @IBOutlet var customView: CustomSegmentControl?
    
    var eventViewModel = EventViewModel()
    var selectedImageURL = String()
    var pageCount : Int = 1
    var selectedType: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem (title: "", style: .done, target: nil, action: nil) // Hide Back Button
        self.tableView?.registerCellNib(EventsTableViewCell.self)
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Colors.DeepSaffron, Colors.normalWhite, Colors.IndiaGreen])

        self.topView?.backgroundColor = Colors.DeepSaffron
        geteventDatafromAPI(pageNo: pageCount, type: 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func geteventDatafromAPI(pageNo: Int ,type: Int) {
        if Reachability()?.currentReachabilityString != "No Connection" {
            eventViewModel.fetchAlleventData(page: pageNo, eventtype: type, completionCallback: { (isSuccess, error) in
                if isSuccess {
                    self.tableView?.reloadData()
                } else if let someError = error {
                    self.handleError(someError)
                }
            }) { (message) in
                self.alertController(title: nil, message: message, actionTitle: "OK", handler: nil)
            }
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
    }
    
    @IBAction func customSegmentAction(_ sender: CustomSegmentControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            eventViewModel.eventsData.removeAll()
            pageCount = 1
            geteventDatafromAPI(pageNo: pageCount, type: 1)
            self.tableView?.reloadData()
            selectedType = 1
        case 1:
            eventViewModel.eventsData.removeAll()
            pageCount = 1
            geteventDatafromAPI(pageNo: pageCount, type: 2)
            self.tableView?.reloadData()
            selectedType = 2
        default:
            break
        }
    }
    
    @IBAction func callBarButtonAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "notifiSegue", sender: self)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imageSegue" {
            let imageVC = segue.destination as! ImageZoomViewController
            imageVC.ImageURL = selectedImageURL
        }
    }
}

// MARK : - UITableView Methods

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventViewModel.numberOfEventsItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = eventViewModel.eventItemAtIndex(index: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsTableViewCell.identifier, for: indexPath)
        if let Cell = cell as? EventsTableViewCell, let imageStr = data.event_image, let imgurl = URL(string: imageStr) {
            Cell.eventsHeadingLabel?.text = data.event_name
            Cell.eventsDateLabel?.text = data.event_date
            Cell.eventsTimeLabel?.text = data.event_time
            Cell.eventsAddressLabel?.text = data.event_address
            Cell.eventsImageView?.af_setImage(withURL: imgurl, placeholderImage: UIImage (named: "imageholder"))
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = eventViewModel.eventItemAtIndex(index: indexPath)
        if let image = data.event_image {
            selectedImageURL = image
        }
        self.performSegue(withIdentifier: "imageSegue", sender: self)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height-500)) {
            pageCount += 1
            geteventDatafromAPI(pageNo: pageCount, type: selectedType)
        }
    }
}

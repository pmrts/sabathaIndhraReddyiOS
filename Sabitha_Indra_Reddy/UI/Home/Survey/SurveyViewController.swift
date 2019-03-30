//
//  SurveyViewController.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 05/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import SwiftyJSON

class SurveyViewController: UIViewController {

    var listjson: JSON = JSON.null
    var surveyViewModel = SurveyViewModel()
    var pageCount: Int = 1
    
    @IBOutlet var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.registerCellNib(SurveyTableViewCell.self)
        checkingUserLogging()
        self.navigationItem.backBarButtonItem = UIBarButtonItem (title: "", style: .done, target: nil, action: nil) // Hide Back Button
        fetchPollDataandReload()
        self.navigationController?.navigationBar.applyNavigationGradient(colors: [Colors.DeepSaffron, Colors.normalWhite, Colors.IndiaGreen])

        NotificationCenter.default.addObserver(self, selector: #selector(refreshViewWhenSurverySubmitted), name: .RefreshSurvey, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView?.reloadData()
    }
    
    func checkingUserLogging() {
        if SabithaUserDefaults.isLoggedIn {
           
        } else {
            let alert = UIAlertController (title: "Register or Login", message: "To Take a Survey, Please Login or Register", preferredStyle: .alert)
            let action = UIAlertAction (title: "OK", style: .default) { (action) in
                AuthGuard.showAuthentication()
            }
            let action1 = UIAlertAction (title: "Cancel", style: .cancel) { (action) in
                
            }
            alert.addAction(action)
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchPollDataandReload() {
        if Reachability()?.currentReachabilityString != "No Connection" {
            surveyViewModel.fetchAllPollData(page: self.pageCount, completionCallback: { (isSuccess, error) in
                    if isSuccess {
                        self.tableView?.reloadData()
                    } else if let someError = error {
                         self.tableView?.reloadData()
                        print(someError.localizedDescription)
                        self.handleError(someError)
                    }
            }) { (message) in
                self.alertController(title: nil, message: message, actionTitle: "Ok", handler: nil)
            }
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
     }
    
    @IBAction func callBarButtonAction(_ sender: UIBarButtonItem) {
       //UIApplication.shared.open(URL(string: "tel://9500560001")!, options: [:], completionHandler: nil)
        self.performSegue(withIdentifier: "notifiSegue", sender: self)
    }
    
    @objc func refreshViewWhenSurverySubmitted(_ info: Notification) {
        guard let value = info.object as? Int else {
            return
        }
        if value == 1 {
            surveyViewModel.pollData.removeAll()
            fetchPollDataandReload()
        }
    }
}

// MARK : - UITableView Methods

extension SurveyViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveyViewModel.numberOfSurveyQuestions()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SurveyTableViewCell.identifier, for: indexPath)
        let data = surveyViewModel.surveyQuestionAtIndex(index: indexPath)
        if let Cell = cell  as? SurveyTableViewCell {
            Cell.SurveyDateLabel?.text = data.survey_date
            Cell.SurveyNumberLabel?.text = data.survey_unique_display_id
            Cell.SurveyQuestionLabel?.text = data.survey_main_question
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if SabithaUserDefaults.isLoggedIn {
            let data = surveyViewModel.surveyQuestionAtIndex(index: indexPath)
            if let id = data.survey_id {
                User.sharedInstance.surveyID = id
            }
            self.performSegue(withIdentifier: "questionSegue", sender: self)
        } else {
            let alert = UIAlertController (title: "Register or Login", message: "To Take a Survey, Please Login or Register", preferredStyle: .alert)
            let action = UIAlertAction (title: "OK", style: .default) { (action) in
                AuthGuard.showAuthentication()
            }
            let action1 = UIAlertAction (title: "Cancel", style: .cancel) { (action) in
                
            }
            alert.addAction(action)
            alert.addAction(action1)
            self.present(alert, animated: true, completion: nil)
        }
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
            fetchPollDataandReload()
        }
    }
}

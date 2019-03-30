//
//  InitialPageViewController.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 19/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit

class InitialPageViewController: UIPageViewController {

    var surveyDetailViewModel = SurveyDetailViewModel()
    var answersChosen = Array<SurveySubmit>()
    
    private(set) var orderedViewControllers = [QuestionsViewController]()
    
    var updatePageControl : ((_ pageNumber:Int)->Void)?
    var numberOfPages : ((_ total:Int)->Void)?
    
    fileprivate func setupUI() {
        for i in 0 ..< surveyDetailViewModel.numberOfQuestions() {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let QuesVC = sb.instantiateViewController(withIdentifier: "QuestionsViewController") as? QuestionsViewController
            QuesVC?.surveyQuestion = surveyDetailViewModel.questionAtIndex(index: i)
            QuesVC?.optionDelegate = self
            if i == surveyDetailViewModel.numberOfQuestions() - 1 {
                 QuesVC?.shouldShowDone = true
            }
            orderedViewControllers.append(QuesVC!)
        }
        numberOfPages?(orderedViewControllers.count)
        if let firstViewController = orderedViewControllers.first { setViewControllers([firstViewController],
                                                                                        direction: .forward,
                                                                                        animated: true,
                                                                                        completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        dataSource = self
        delegate = self

        modelFetchData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func modelFetchData() {
        if Reachability()?.currentReachabilityString != "No Connection" {
            surveyDetailViewModel.fetchAllSurveyDetailData(suveryid: User.sharedInstance.surveyID) { (isSuccess, error) in
                if isSuccess {
                    self.setupUI()
                } else if let someError = error {
                    print(someError.localizedDescription)
                }
            }
        } else {
            alertController(title: Constants.connectionTitle, message: Constants.connectionMessage, actionTitle: "OK", handler: nil)
        }
    }
    
    func submitSurvey(answers: [[String: Any]]) {
            if Reachability()?.currentReachabilityString != "No Connection" {
                SabithaNetworkAdapter.request(target: .submitSurvey(surveyid: User.sharedInstance.surveyID, pollAnswers: answers), success: { (response) in
                    print(response)
                    self.alertController(title: "Thank You", message: nil, actionTitle: "OK", handler: { (action) in
                        NotificationCenter.default.post(name: .RefreshSurvey, object: 1)
                        self.navigationController?.popViewController(animated: true)
                    })
                }, error: { (error) in
                    print(error.localizedDescription)
                    self.handleError(error)
                }) { (error) in
                    print(error)
                }
            } else {
    
            }
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

extension InitialPageViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed == true {
            if let controller = pageViewController.viewControllers?.last as? QuestionsViewController, let index = orderedViewControllers.index(of: controller) {
                updatePageControl?(index)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? QuestionsViewController, let viewControllerIndex = orderedViewControllers.index(of: vc) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? QuestionsViewController, let viewControllerIndex = orderedViewControllers.index(of: vc) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }

}

extension InitialPageViewController : SubmitSurveyProtocol {
    func submitAnswers() {
        if answersChosen.count == surveyDetailViewModel.numberOfQuestions() {
            let answers = answersChosen.map { (answer) in
                return ["poll_option_id": answer.poll_option_id, "poll_question_id": answer.poll_question_id, "remarks": answer.remarks ?? ""]
            }
            self.submitSurvey(answers: answers)
        } else {
            alertController(title: nil, message: "Please Answer all Survey Questions", actionTitle: "OK", handler: nil)
        }
    }
    
    
    func submitSurveywithAnswer(surveyAnswer: SurveySubmit) {
        if let index = answersChosen.index(where: { $0.poll_question_id == surveyAnswer.poll_question_id }) {
            answersChosen.remove(at: index)
        }
        answersChosen.append(surveyAnswer)
    }
}

//
//  QuestionsViewController.swift
//  KiranBedi
//
//  Created by Aditya Bonthu on 08/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol SubmitSurveyProtocol {
    func submitSurveywithAnswer(surveyAnswer: SurveySubmit)
    func submitAnswers()
}

class QuestionsViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var tableView: UITableView?
    @IBOutlet var doneButton: UIButton?
    
    @IBOutlet var remarksTextView: UITextView?
    
    var optionDelegate : SubmitSurveyProtocol?
    
    var surveyQuestion: SurveyQuestion?
    var shouldShowDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.registerCellNib(OptionsTableViewCell.self)
        self.tableView?.registerHeaderFooterViewNib(SurveyQuestionView.self)
        self.tableView?.registerHeaderFooterViewNib(RemarksTableViewCell.self)
        doneButton?.layer.cornerRadius = (doneButton?.frame.height)! / 2
        
        doneButton?.isHidden = !shouldShowDone
        remarksTextView?.isHidden = !shouldShowDone
        self.tableView?.tableFooterView = remarksTextView
    
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .KeyboardShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .KeyboardHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: .KeyboardShow , object: nil)
        NotificationCenter.default.removeObserver(self, name: .KeyboardHide , object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonAction(_ sender: UIButton) {
        optionDelegate?.submitAnswers()
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.tableView!.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.tableView?.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.tableView?.contentInset = contentInset
    }
    
}
// MARK : - *** TableView Methods ***

extension QuestionsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let options = self.surveyQuestion?.options {
            return options.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionsTableViewCell.identifier, for: indexPath) as! OptionsTableViewCell
        let option = self.surveyQuestion?.options[indexPath.row]
        
        cell.optionLabel?.text = option?.option_value
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? OptionsTableViewCell
        guard let optionID = self.surveyQuestion?.options[indexPath.row].option_id, let quesID = self.surveyQuestion?.question_id else { return }
        cell?.cellSelected()
        
        let chosenAnswer = SurveySubmit(questionID: quesID, optionID: optionID, remarks: remarksTextView?.text ?? "")
        optionDelegate?.submitSurveywithAnswer(surveyAnswer: chosenAnswer)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? OptionsTableViewCell
        cell?.optionButton?.isSelected = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: SurveyQuestionView.identifier) as! SurveyQuestionView
        cell.questionLabel?.text = self.surveyQuestion?.question_name
        return cell
    }
    
}

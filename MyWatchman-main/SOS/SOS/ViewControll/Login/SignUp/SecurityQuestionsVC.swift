//
//  SecurityQuestionsVC.swift
//  SOS
//
//  Created by Alpesh Desai on 28/12/20.
//

import UIKit

class SecurityQuestionsVC: UIViewController {

    var questions = [SecurityQuestionData]() {
        didSet {
            if let info = UserInfo.savedUser(), let que = questions.filter({$0.Id == info.SecurityQuestionId}).first {
                question = que
            } else  {
                if let first = questions.first {
                    question = first
                }
            }
        }
    }
    var param = [String : Any]()
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtAns: LetsTextField!
    var question : SecurityQuestionData? {
        didSet {
            if let que = question {
                lblQuestion.text = que.Questions.replacingOccurrences(of: "\n", with: "")
            }
        }
    }
    
    var completionBlock : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        callGetQuestionList { (data) in
            self.questions = data
        }
        if completionBlock == nil {
            btnBack.isHidden = false
            btnCancel.isHidden = false
        } else {
            btnBack.isHidden = true
            btnCancel.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackCLK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        registerData = RegisterData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnQuestionsCLK(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: questions.compactMap({$0.Questions})) { (que, index) in
            self.question = self.questions[index]
        }
    }

    @IBAction func btnSubmitCLK(_ sender: UIButton) {
        if txtAns.text!.trim.isEmpty {
            return
        }
        guard let que = self.question else {
            return
        }
        if let info = UserInfo.savedUser(), completionBlock != nil {
            if txtAns.text!.lowercased() == info.Answer.lowercased() {
                self.completionBlock!()
                self.navigationController?.popViewController(animated: true)
            } else {
                showAlert("Answer not match")
            }
            
        } else {
            param["SecurityQuestionId"] = que.Id
            param["Answer"] = txtAns.text!
            print(param)
            
            self.callPostUserDataAPI(url: baseURL+URLS.Signup.rawValue, param: param) { (info) in
                if let info = info {
                    info.save()
                    registerData = RegisterData()
                    let controll = LoginBord.instantiateViewController(identifier: "WelcomeScreenVC") as! WelcomeScreenVC
                    self.navigationController?.pushViewController(controll, animated: true)
                    //UserDefaults.standard.setValue(true, forKey: "PlanRemain")
                    //appDelegate.gotToPlanSelection()
                    
                }
            }
        }
    }
}

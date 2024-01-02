//
//  SurveyTaskVC.swift
//  iCognizance
//
//  Created by MickyBahu on 12/01/19.
//  Copyright © 2019 InfoLabh. All rights reserved.
//

import UIKit
import WatchConnectivity
import HealthKit
import FloatRatingView

class SurveyTaskCell : UICollectionViewCell {
    
    @IBOutlet weak var viewSlab: LetsView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        viewSlab.cornerRadius = 3.0
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class SurveyMCQAnsCell : UITableViewCell {
    
    @IBOutlet var lblAnsa: UILabel!
    @IBOutlet var viewAnsBag: LetsView!
    @IBOutlet  var viewCircles: LetsView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class SurveyTextAnsCell : UITableViewCell, UITextViewDelegate {
    
    @IBOutlet var txtAns: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

class SurveyTaskVC: UIViewController {
    
    @IBOutlet weak var lblTitleIndex: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tblQueAns: UITableView!
    @IBOutlet weak var heightSlapCon: NSLayoutConstraint!
    
    @IBOutlet weak var viewNoteBg: UIView!
    @IBOutlet weak var txtNote: LetsTextView!
    @IBOutlet weak var ratingView: FloatRatingView!
    
    var selectedIndex = 0
    
    struct QueationData {
        var question = ""
        var ans = [String]()
        var flag = [Bool]()
    }
    
    var sosId = 0
    var arrQuest = [QueationData]()
    var completionBLK : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        title = ""
        viewNoteBg.isHidden = true
        arrQuest.append(QueationData(question: "How long did it take the responder to arrive at your SOS location?", ans: ["0 to 10 Minutes","11 to 20 Minutes","More than 20 Minutes"], flag: [false,false,false]))
        
        self.lblTitleIndex.text = "1)"
        self.lblQuestion.text = arrQuest[selectedIndex].question
        
        arrQuest.append(QueationData(question: "How would you describe your experience?", ans: ["Excellent","Good","Average","Worse"], flag: [false,false,false,false]))
        
        arrQuest.append(QueationData(question: "How would you rate the quality of our SOS services?", ans: ["Extremely High Quality","High Quality","Average Quality","Low Quality"], flag: [false,false,false,false]))
        
        arrQuest.append(QueationData(question: "Overall, how satisfied are you with the services you received from our SOS by Watchman?", ans: ["Very Satisfied","Satisfied","Dissatisfied","Very dissatisfied"], flag: [false,false,false,false]))
        
        arrQuest.append(QueationData(question: "Would you recommend SOS by Watchman to others?", ans: ["Yes","No"], flag: [false,false]))
        
        
    }

    @IBAction func btnSubmitAnsCLK(_ sender: UIButton) {
        let dict = arrQuest.compactMap { (data) -> [String : String] in
            var param = [String : String]()
            param["Question"] = data.question
            if let index = data.flag.firstIndex(of: true) {
                param["Answer"] = data.ans[index]
            }
            return param
        }
        print(dict)
        
        if ratingView.rating == 0.0 {
            showAlert("Please enter rating")
            return
        }
        
        alertShow(self, title: "Message", message: "By submitting, I confirm that I have answered all questions truthfully and completely.Both caller and responder(s) are no longer in danger or in need of immediate assistance at the time of this documentation.", okStr: "Ok", cancelStr: "Cancel") {
            let ratParam = ["CustomerId": UserInfo.savedUser()!.Id,
                            "SOSId": self.sosId,
                            "Rating": Int(self.ratingView.rating)]
            print(ratParam)
            self.callPostRatingDetail(param: ratParam) { (data) in
                
            }
            
            let url = baseURL+URLS.QuestionariesInsert.rawValue + "CustomerId=\(UserInfo.savedUser()!.Id)&SOSId=\(self.sosId)&Note=\(self.txtNote.text!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
            
            self.callPostAnsDetail(url: url, param: dict) { (data) in
                if data != nil {
                    self.callCompleteSOS()
//                    if self.completionBLK != nil {
//                        self.completionBLK!()
//                    }
//                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        } cancelClick: {}
        
    }
    
    func callCompleteSOS() {
        callCompleteSOSHistory(sosId: "\(self.sosId)") { (data) in
            if let data = data {
                let controll = MainBoard.instantiateViewController(withIdentifier: "SOSCompletedVC") as! SOSCompletedVC
                controll.time = data.CompletedSOSInMin
                controll.modalPresentationStyle = .fullScreen
                self.present(controll, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnNextCLK(_ sender: UIButton) {
        callAnsForQuestionAPI(sender: sender)
    }
    
    func callAnsForQuestionAPI(sender : UIButton) {
        if selectedIndex == arrQuest.count-1 {
            afterAndGoToNextQue(flag: true)
        } else {
            self.afterAndGoToNextQue(flag: false)
        }
    }
    
  
    func afterAndGoToNextQue(flag : Bool) {
        if arrQuest[selectedIndex].flag.contains(true) {
            if flag {
                //Call API
                viewNoteBg.isHidden = false
        
            }
            else {
                selectedIndex = selectedIndex+1
                self.lblTitleIndex.text = "\(selectedIndex+1))"
                self.lblQuestion.text = arrQuest[selectedIndex].question
                self.tblQueAns.reloadData()
                self.collectionView.reloadData()
            }
        }
    }
}

extension SurveyTaskVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrQuest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurveyTaskCell", for: indexPath) as! SurveyTaskCell
        cell.viewSlab.backgroundColor = selectedIndex == indexPath.item ?  #colorLiteral(red: 0.2389999926, green: 0.6549999714, blue: 0.97299999, alpha: 1) : UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let widht = collectionView.frame.size.width/10
        return CGSize(width: widht, height: 5)
    }
}

extension SurveyTaskVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQuest[selectedIndex].ans.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SurveyMCQAnsCell", for: indexPath) as! SurveyMCQAnsCell
        cell.lblAnsa.text = arrQuest[selectedIndex].ans[indexPath.row]
        if arrQuest[selectedIndex].flag[indexPath.row] {
            cell.viewAnsBag.backgroundColor = #colorLiteral(red: 0.2389999926, green: 0.6549999714, blue: 0.97299999, alpha: 1)
            cell.viewCircles.backgroundColor = #colorLiteral(red: 0.2389999926, green: 0.6549999714, blue: 0.97299999, alpha: 1)
        }
        else {
            cell.viewAnsBag.backgroundColor = UIColor.clear
            cell.viewCircles.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in 0..<arrQuest[selectedIndex].flag.count {
            arrQuest[selectedIndex].flag[index] = false
        }
        arrQuest[selectedIndex].flag[indexPath.row] = true
        tableView.reloadData()
    }
}

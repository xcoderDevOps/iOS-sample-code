//
//  CommentListVC.swift
//  CargoDriver
//
//  Created by infolabh on 15/06/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class CommentCell : UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblComment: UILabel!
}

class CommentListVC: UIViewController {

    var isFromCarrier = false
    var commentArray = [CommentData]()
    var jobData = JobData()
    var driverId = 0
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtComment: LetsTextField!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callCommentList()
        title = jobData.JobNo
        backButton(color: UIColor.white)
        if isFromCarrier {
            bottom.constant = 50.0
        } else {
            bottom.constant = 0.0
        }
        // Do any additional setup after loading the view.
    }
    
    
    func callCommentList() {
        let url = baseURL + URLS.JobDriverComments_All.rawValue + "JobId=\(jobData.Id)&DriverId=\(driverId)"
        callCommentList(url: url) { (data) in
            self.commentArray = data
            self.tableView.reloadData()
        }
    }

    @IBAction func btnSendMsgCLK(_ sender: UIButton) {
        if txtComment.text!.isEmpty {
            return
        }
        self.view.endEditing(true)
        let param = [   "JobId":jobData.Id,
                        "Comment":txtComment.text!,
                        "UserType":2,
                        "DriverId":driverId] as [String : Any]
        callAddComment(url: baseURL+URLS.JobDriverComments_Upsert.rawValue, param) { (data) in
            if data != nil {
                self.txtComment.text = ""
                self.callCommentList()
            }
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

extension CommentListVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        let obj = self.commentArray[indexPath.row]
        if obj.UserType == 2 {
            cell.lblName.text = "Carrier"
        } else {
            cell.lblName.text = jobData.DriverName     + "(Driver)"
        }
        
        cell.lblDate.text = obj.CreatedDateStr
        cell.lblComment.text = obj.Comment
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

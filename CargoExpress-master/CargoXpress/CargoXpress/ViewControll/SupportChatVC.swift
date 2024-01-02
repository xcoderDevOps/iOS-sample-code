//
//  SupportChatVC.swift
//  GoldClean
//
//  Created by infolabh on 19/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class SupportTableCell : UITableViewCell {
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
}

class SupportChatVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtMessage: LetsTextField!
    @IBOutlet weak var btnSendMsg: UIButton!
    @IBOutlet weak var lblPhoneNo: UILabel!
    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblJobSubTitle: UILabel!
    @IBOutlet weak var btnTickt: UIButton!
    
    @IBOutlet weak var heightChatText: NSLayoutConstraint!
    
    var supportData = SupportData()
    
    var supportChatList = [SupportChatData]()
    var timer : Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton(color: UIColor.white)
        title = supportData.Issue
        callSupportChatListAPI(supportId: supportData.Id, flag : true) { (data) in
            self.supportChatList = data
            self.tableView.reloadData()
        }
        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(callChatList), userInfo: nil, repeats: true)
        
        if supportData.Status == "Solved" {
            btnTickt.isHidden = true
            heightChatText.constant = 0.0
            
        } else {
            btnTickt.isHidden = false
            heightChatText.constant = 56.0
        }
        
        lblJobTitle.text = supportData.Issue
        lblJobSubTitle.text = supportData.CreatedDateStr
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func callChatList() {
        callSupportChatListAPI(supportId: supportData.Id, flag : false) { (data) in
            
            self.supportChatList = data
            self.tableView.reloadData()
        }
    }
    @IBAction func btnSendMessageAction(_ sender: UIButton) {
        if !txtMessage.text!.isEmpty {
            let param = [
                    "SupportId": supportData.Id,
                    "ReplyText": txtMessage.text!,
                    "UserTypeId": appDelegate.isFindService ? 3 : 2,
                    "ReplyDate": Date().toString("yyyy-MM-dd'T'HH:mm:ss.SSSZ")!,
                    "ReplyDateStr": Date().toString("dd-MMM-yyyy hh:mm a")! ] as [String : Any]
            wsSendReplyCLK(param: param) { (data) in
                if let data = data {
                    self.txtMessage.text = ""
                    self.supportChatList.append(data)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func btnCloseTicketCLK(_ sender: LetsButton) {
        wsSupportCloseCLK(id: supportData.Id) { (data) in
            if let data = data {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    @IBAction func btnTapToCall(_ sender: UIButton) {
        
    }
}

extension SupportChatVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.supportChatList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatData = self.supportChatList[indexPath.row]
        if appDelegate.isFindService && chatData.UserTypeId == "3" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSender") as! SupportTableCell
            cell.lblMessage.text = chatData.ReplyText
            return cell
        } else if chatData.UserTypeId == "2" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellSender") as! SupportTableCell
            cell.lblMessage.text = chatData.ReplyText
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellReceiver") as! SupportTableCell
            cell.lblMessage.text = chatData.ReplyText
            return cell
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

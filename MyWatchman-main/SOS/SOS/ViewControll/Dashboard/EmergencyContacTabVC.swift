//
//  EmergencyContacVC.swift
//  SOS
//
//  Created by Alpesh Desai on 28/12/20.
//

import UIKit

class ContactCell : UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var lblRelation: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var lblFirstLater: UILabel!
    @IBOutlet weak var viewLater: UIView!
    
    @IBOutlet weak var viewRelation: UIView!
    @IBOutlet weak var viewStatus: UIView!
    
    var blockAction : (()->())?
    var blockDelet : (()->())?
    
    @IBAction func btnAction(_ sender: UIButton) {
        if blockAction != nil {
            blockAction!()
        }
    }
    
    @IBAction func btnDeleteContact(_ sender: UIButton) {
        if blockDelet != nil {
            blockDelet!()
        }
    }
}

class RequestCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblFirstLater: UILabel!
    @IBOutlet weak var viewLater: UIView!
    
    var blockAcceptAction : (()->())?
    var blockRejectAction : (()->())?
    
    @IBAction func btnAcceptCLK(_ sender: UIButton) {
        if blockAcceptAction != nil {
            blockAcceptAction!()
        }
    }
    
    @IBAction func btnRejectCLK(_ sender: UIButton) {
        if blockRejectAction != nil {
            blockRejectAction!()
        }
    }
    
}

class EmergencyContacTabVC: UIViewController {

    var arrayContacts = [ContactData]()
    var requestData = [UserInfo]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet weak var xAxhis: NSLayoutConstraint!
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var btnRequest: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftMenuButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callAPI()
        dashTabVC?.title = "Emergency Contacts"
    }
    
    func callAPI() {
        callGetContactAll { (data) in
            self.arrayContacts = data
            self.tableView.reloadData()
        }
        callGetRequestData(baseURL+URLS.ContactByEmailcustomer.rawValue+"\(UserInfo.savedUser()!.Mobile.replacingOccurrences(of: "+", with: "%2B"))&Offset=0&Limit=10000") { (data) in
            self.requestData = data
            self.lblCount.text = "\(data.count)"
            self.lblCount.isHidden = data.isEmpty
            self.tableView.reloadData()
        }
    }
    
    @IBAction func btnAddContact(_ sender: UIButton) {
        let controll = MainBoard.instantiateViewController(identifier: "AddContactVC") as! AddContactVC
        self.navigationController?.pushViewController(controll, animated: true)
    }

    
    @IBAction func tapToClickOnTap(_ sender: UIButton) {
        xAxhis.constant = sender.frame.origin.x
        btnContact.isSelected = false
        btnRequest.isSelected = false
        sender.isSelected = true
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
        }
        self.tableView.reloadData()
    }
}

extension EmergencyContacTabVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if btnContact.isSelected {
            return arrayContacts.count
        } else {
            return requestData.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if btnContact.isSelected {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
            let obj = arrayContacts[indexPath.row]
            cell.lblName.text = obj.ContactName
            cell.lblName.isHidden = obj.ContactName.isEmpty
            
            cell.lblEmail.text = obj.ContactEmail
            cell.lblEmail.isHidden = obj.ContactEmail.isEmpty
            
            let color1 = UIColor.random(alpha: 0.7)
            cell.viewRelation.backgroundColor = color1
            cell.lblRelation.textColor = UIColor.white
            cell.lblRelation.text = obj.Relation
            cell.viewRelation.isHidden = obj.Relation.isEmpty
            
            cell.lblContact.text = obj.ContactPhone
            cell.lblContact.isHidden = obj.ContactPhone.isEmpty
            
            if let f = obj.ContactName.first {
                cell.lblFirstLater.text = "\(f)"
            }
            let color2 = UIColor.random(alpha: 0.7)
            
            cell.viewLater.backgroundColor = color2
            cell.lblFirstLater.textColor = UIColor.white
            
            let color3 = UIColor.random(alpha: 0.7)
            cell.viewStatus.backgroundColor = color3
            cell.lblStatus.textColor = UIColor.white
            cell.lblStatus.text = "Pending"
            cell.viewStatus.isHidden = obj.ApprovedStatus
            
            
            cell.blockAction = { () -> Void in
                let controll = MainBoard.instantiateViewController(identifier: "AddContactVC") as! AddContactVC
                controll.contactData = self.arrayContacts[indexPath.row]
                self.navigationController?.pushViewController(controll, animated: true)
            }
            
            cell.blockDelet = { () -> Void in
                self.alertShow(self, title: "", message: "Are you sure you want to delete this contact?", okStr: "Yes", cancelStr: "No") {
                    let url = baseURL + URLS.DeleteContact.rawValue + "\(self.arrayContacts[indexPath.row].Id)"
                    self.callDeleteContact(url) { (str) in
                        if str == "true" {
                            self.arrayContacts.remove(at: indexPath.row)
                            self.tableView.reloadData()
                        }
                    }
                } cancelClick: {}
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell") as! RequestCell
            let obj = requestData[indexPath.row]
            cell.lblTitle.text = "\(obj.FirstName + " " + obj.LastName) sends you a request to be an emergency contact of him"
            cell.blockAcceptAction = { () -> Void in
                let url = baseURL + URLS.EmergencyConUpdateStatus.rawValue + "\(self.requestData[indexPath.row].Id)&ApprovedStatus=true"
                self.callApproveReject(url: url) { (flag) in
                    self.callAPI()
                }
            }
            cell.blockRejectAction = { () -> Void in
                let url = baseURL + URLS.EmergencyConUpdateStatus.rawValue + "\(self.requestData[indexPath.row].Id)&ApprovedStatus=false"
                self.callApproveReject(url: url) { (flag) in
                    self.callAPI()
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


extension UIColor {
    static func random(alpha:CGFloat) -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: alpha
        )
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

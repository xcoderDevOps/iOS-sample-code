//
//  UsersVC.swift
//  SOS
//
//  Created by Alpesh Desai on 28/12/20.
//

import UIKit

class UserListCell : UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var stackPhone: UIStackView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var stackEmail: UIStackView!
    
    var blockPhone : (()->())?
    var blockMessage : (()->())?
    var blockAction : (()->())?
    
    @IBAction func btnActionClk(_ sender: UIButton) {
        if blockAction != nil {
            blockAction!()
        }
    }
    
    @IBAction func btnPhoneClk(_ sender: UIButton) {
        if blockPhone != nil {
            blockPhone!()
        }
    }
    
    @IBAction func btnEmailClk(_ sender: UIButton) {
        if blockMessage != nil {
            blockMessage!()
        }
    }
}

class UsersVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var arrayUser = [UserInfo]()
    
    static var refresh = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton()
        title = "Manage Users"
        
        self.appCall()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UsersVC.refresh {
            UsersVC.refresh = false
            self.appCall()
        }
    }
    
    func appCall() {
        callGetSubUserData(baseURL+URLS.GetSub_Customer_All.rawValue+"\(UserInfo.savedUser()!.Id)&Offset=0&Limit=10000") { (data) in
            self.arrayUser = data
            self.tableView.reloadData()
        }
    }
    
    @IBAction func btnAddUserClk(_ sender: UIButton) {
        let controll = MainBoard.instantiateViewController(identifier: "AddSubUserVC") as! AddSubUserVC
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    func choosePicker(index : Int) {
        let alertController = UIAlertController(title: "My Watchman", message: "Select an option", preferredStyle: (IS_IPAD ? UIAlertController.Style.alert : UIAlertController.Style.actionSheet))
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action -> Void in
        })
        let edit = UIAlertAction(title: "Edit Profile", style: UIAlertAction.Style.default
            , handler: { action -> Void in
                let controll = MainBoard.instantiateViewController(identifier: "AddSubUserVC") as! AddSubUserVC
                controll.userData = self.arrayUser[index]
                self.navigationController?.pushViewController(controll, animated: true)
        })
        let delete = UIAlertAction(title: "Delete Profile", style: UIAlertAction.Style.default
            , handler: { action -> Void in
            let url = baseURL+URLS.CustomerDelete.rawValue+"\(self.arrayUser[index].Id)"
            self.callDeleteContact(url) { (str) in
                if str == "true" {
                    self.arrayUser.remove(at: index)
                    self.tableView.reloadData()
                }
            }
        })
        let change = UIAlertAction(title: "Change Password", style: UIAlertAction.Style.default
            , handler: { action -> Void in
                let controll = LoginBord.instantiateViewController(identifier: "ResetPasswordVC") as! ResetPasswordVC
                controll.info = self.arrayUser[index]
                self.navigationController?.pushViewController(controll, animated: true)
        })
        alertController.addAction(edit)
        alertController.addAction(delete)
        alertController.addAction(change)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UsersVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayUser.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListCell") as! UserListCell
        let obj = self.arrayUser[indexPath.row]
        cell.lblName.text = obj.FirstName + " " + obj.LastName
        cell.lblPhone.text = obj.Mobile
        cell.stackPhone.isHidden = obj.Mobile.isEmpty
        cell.lblEmail.text = obj.Email
        cell.stackEmail.isHidden = obj.Email.isEmpty
        cell.blockPhone = { () -> Void in
            UIApplication.shared.canOpenURL(URL(string: "tel://\(obj.Mobile)")!)
        }
        cell.blockMessage = { () -> Void in
            let appURL = URL(string: "mailto:\(obj.Email)")!
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        }
        cell.blockAction = { () -> Void in
            self.choosePicker(index: indexPath.row)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controll = MainBoard.instantiateViewController(identifier: "AddSubUserVC") as! AddSubUserVC
        controll.userData = self.arrayUser[indexPath.row]
        self.navigationController?.pushViewController(controll, animated: true)
    }
}

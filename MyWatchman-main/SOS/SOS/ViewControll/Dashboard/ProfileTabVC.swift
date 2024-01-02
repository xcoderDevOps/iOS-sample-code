//
//  ProfileTabVC.swift
//  SOS
//
//  Created by Alpesh Desai on 13/07/21.
//

import UIKit
import Kingfisher

class ProfileTabCell: UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgView:UIImageView!
}

class ProfileTabVC: UIViewController {

    var arrTitle = ["Medical Info", "Insurance Info", "Statistic", "Billing", "Manage Users", "Logout"]
    var arrImages = ["ic_medical","ic_insurance","ic_statistic","ic_billing","ic_userdata","ic_logout"]
    
    @IBOutlet weak var tableView:UITableView!
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imageProfile:LetsImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = UserInfo.savedUser() {
            lblTitle.text = data.FirstName + " " + data.LastName
            
            if data.UserType == 2 {
                arrTitle = ["Medical Info", "Insurance Info", "Statistic", "Billing", "Logout"]
                arrImages = ["ic_medical","ic_insurance","ic_statistic","ic_billing","ic_logout"]
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dashTabVC?.title = "My Profile"
        if let data = UserInfo.savedUser() {
            lblTitle.text = data.FirstName + " " + data.LastName
            self.imageProfile.borderWidth = 0.0
            if let str = data.ProfilePicture.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) , let url = URL(string: str) {
                let source = ImageResource(downloadURL: url)
                self.imageProfile.kf.setImage(with: source, placeholder:UIImage(named: "ic_profile"))
                self.imageProfile.borderWidth = 2.0
            }
        }
    }
    
    @IBAction func tapToOpenEditProfile(_ sender: UIButton) {
        let controll = MainBoard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(controll, animated: true)
    }

}

extension ProfileTabVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTabCell") as! ProfileTabCell
        cell.lblTitle.text = arrTitle[indexPath.row]
        cell.imgView.image = UIImage(named: arrImages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch arrTitle[indexPath.row] {
        case "Medical Info":
            let controll = MainBoard.instantiateViewController(withIdentifier: "MedicalnfoVC") as! MedicalnfoVC
            self.navigationController?.pushViewController(controll, animated: true)
        case "Insurance Info":
            let controll = MainBoard.instantiateViewController(withIdentifier: "InsurangeInfoVC") as! InsurangeInfoVC
            self.navigationController?.pushViewController(controll, animated: true)
        case "Statistic":
            let controll = MainBoard.instantiateViewController(withIdentifier: "StatisticsVC") as! StatisticsVC
            self.navigationController?.pushViewController(controll, animated: true)
        case "Billing":
            let controll = MainBoard.instantiateViewController(withIdentifier: "BillingVC") as! BillingVC
            self.navigationController?.pushViewController(controll, animated: true)
        case "Manage Users":
            let controll = MainBoard.instantiateViewController(withIdentifier: "UsersVC") as! UsersVC
            self.navigationController?.pushViewController(controll, animated: true)
        case "Logout":
            alertShow(self, title: "", message: "Are you sure you want to Logout?", okStr: "Yes", cancelStr: "No", okClick: {
                UserInfo.clearUser()
                appDelegate.gotToSigninView()
                self.dismiss(animated: true, completion: nil)
            }) {
                self.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

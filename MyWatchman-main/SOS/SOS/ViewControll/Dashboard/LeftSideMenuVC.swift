//
//  LeftSideMenuVC.swift
//  SOS
//
//  Created by Alpesh Desai on 26/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import StoreKit
import Kingfisher

class LeftMenuCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
}

var leftSideMenu : LeftSideMenuVC?
class LeftSideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lblUSerName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    /*
     
     var arrNav = ["DashboardVC", "EditProfileVC", "AddressVC", "EmergencyContacVC", "UsersVC", "MedicalnfoVC", "InsurangeInfoVC", "BillingVC", "SOSHistoryVC","StatisticsVC","NotificationVC"]
     
     if data.UserType == 2 {
         arrNav = ["DashboardVC", "EditProfileVC", "SOSHistoryVC","StatisticsVC", "MedicalnfoVC", "InsurangeInfoVC","NotificationVC"]
         arrTitle = ["Dashboard", "Profile", "SOS History", "Statistics", "Medical Info", "Insurance Info", "Notification", "Logout"]
         
     }
     */
    
    var selectedIndex = 0
    var arrTitle = ["Rate Application", "Share Application", "Logout"]
    var imgArray = ["ic_stard", "ic_share", "ic_logoutside"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftSideMenu = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let data = UserInfo.savedUser() {
            lblUSerName.text = data.FirstName + " " + data.LastName
            lblEmail.text = data.Email
            if let str = data.ProfilePicture.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: str) {
                let source = ImageResource(downloadURL: url)
                self.imgUser.kf.setImage(with: source, placeholder:UIImage(named: "ic_profile"))
            }
            self.tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell") as! LeftMenuCell
        //cell.lblTitle.textColor = selectedIndex == indexPath.row ? UIColor.systemBlue : UIColor.darkGray
        cell.lblTitle.text = arrTitle[indexPath.row]
        cell.imgView.image = UIImage(named: imgArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didselectTableViewCellAtIndex(index: indexPath.row)
        tableView.reloadData()
    }
    
    func didselectTableViewCellAtIndex(index : Int)
    {
        if index == 0 {
            rateApp(id: "1546552945")
        } else if index == 1 {
            if let appLink = URL(string:"https://apps.apple.com/us/app/my-watchman/id1546552945") {
                let activityViewController = UIActivityViewController(activityItems: [appLink], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        } else {
            alertShow(self, title: "", message: "Are you sure you want to Logout?", okStr: "Yes", cancelStr: "No", okClick: {
                UserInfo.clearUser()
                appDelegate.gotToSigninView()
                self.dismiss(animated: true, completion: nil)
            }) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    func rateApp(id : String) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/id\(id)?mt=8&action=write-review") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}

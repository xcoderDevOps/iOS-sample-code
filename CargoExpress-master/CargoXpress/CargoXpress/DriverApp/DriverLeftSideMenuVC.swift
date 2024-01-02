//
//  LeftSideMenuVC.swift
//  GroupNgrab
//
//  Created by alpesh on 21/12/16.
//  Copyright © 2016 alpesh. All rights reserved.
//

import UIKit

var driverLeftSideMenu : DriverLeftSideMenuVC?

class DriverLeftSideMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblName: UILabel!
    

    var selectedIndex = 0
    var arrImg = ["ic_booking","ic_booking","ic_booking","ic_booking","ic_booking","ic_locpin","ic_driver","ic_truck","ic_earning","ic_profile", "ic_support","ic_logout"]//"ic_booking", , ,
    var arrTitle = ["Available Jobs","All Jobs","Post a Job","Return Container","Bid History","My Places","Manage Driver","Manage Truck", "My Earnings","My Profile", "Support","Logout" ] // "Current Bid List", ,
    
    var arrNevigationID = ["AvailableJobListVC","AllCarierJobVC","CarrierShipperLoginVC","ReturnContainerVC","BidHistoryVC","MyPlaceListVC","DriverListVC","CarrierListVC","PaymentHistoryVC","CarrierEditProfileVC", "SupportVC"] //,"AvailableBidListVC" //CarrierEditProfileVC , ,
    
    override func viewDidLoad() {
        super.viewDidLoad()
        driverLeftSideMenu = self as DriverLeftSideMenuVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let info = UserInfo.savedUser() {
            lblName.text = info.FirstName + " " + info.LastName
            let str = info.FileUrlStr.replacingOccurrences(of: " ", with: "%20")
            if let url = URL(string: str) {
                imgProfile.load(url:url)
            }
        }
        tableView.selectRow(at: IndexPath(row: selectedIndex, section: 0), animated:true, scrollPosition: UITableView.ScrollPosition.top)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell") as! LeftMenuCell
        cell.bgView.backgroundColor = selectedIndex == indexPath.row ? UIColor.bgColor() : UIColor.clear
        cell.lblTitle.textColor = selectedIndex == indexPath.row ? UIColor.blueColor() : UIColor.darkGray
        cell.imgView.image = UIImage(named:arrImg[indexPath.row])
        cell.lblTitle.text = arrTitle[indexPath.row]
        cell.lblSubTitle.isHidden = true
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
        if index == arrTitle.count-1 {
            alertShow(self, title: "", message: popUpMessage.logoutStr.rawValue, okStr: "Yes", cancelStr: "No", okClick: {
                UserInfo.clearUser()
                appDelegate.gotToSigninView()
                self.dismiss(animated: true, completion: nil)
            }) {
                self.dismiss(animated: true, completion: nil)
            }
            return;
        }
        if let drawerController = navigationController?.parent as? KYDrawerController {
            
            let openView :UINavigationController = drawerController.mainViewController as! UINavigationController
            
            selectedIndex = index
            openView.viewControllers = [DriverBoard.instantiateViewController(withIdentifier: arrNevigationID[index])]
            drawerController.setDrawerState(.closed, animated: true)
            tableView.reloadData()
        }
    }
    
}

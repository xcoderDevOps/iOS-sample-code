//
//  DashboardVC.swift
//  GoldClean
//
//  Created by infolabh on 18/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import Kingfisher

class DashboardCell : UITableViewCell {
    @IBOutlet weak var imgView: LetsImageView!
    @IBOutlet weak var lblTitle: UILabel!
}

class DashboardVC: UIViewController {
    @IBOutlet weak var tableTruckType: UITableView!
    static var truckTypeArray = [TruckTypeData]()
    static var locationTypeArray = [LocationTypeData]()
    
    var jobList = [JobData]()
    var mainJobList = [JobData]()
    @IBOutlet weak var tableUpcoming: UITableView!
    
    @IBOutlet weak var searchJob: UISearchBar!
    @IBOutlet weak var viewUpComing: UIStackView!
    
    var rightBar : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if carrierSideShipperId != nil {
            if appDelegate.isFindService
            {
                carrierSideShipperId = nil
                leftMenuButton()
            } else {
                backButton(color: UIColor.white)
            }
        } else {
            leftMenuButton()
        }
        
        title = "Select Carrier Type"
        tableUpcoming.isHidden = true
        viewUpComing.isHidden = true
        callGetTruckTypeList { (data) in
            DashboardVC.truckTypeArray = data
            self.tableTruckType.reloadData()
        }
        callGetLocationTypeList { (data) in
            DashboardVC.locationTypeArray = data
        }
        if appDelegate.isFindService {
            callGetUserData(url: baseURL+URLS.Shippers_ById.rawValue+"\(UserInfo.savedUser()!.Id)") { (info) in
                if let info = info {
                    info.isFindService = appDelegate.isFindService
                    info.save()
//                    if !info.IsPlanActive {
//                        let controll = MainBoard.instantiateViewController(identifier: "PurchacePlanVC") as! PurchacePlanVC
//                        controll.modalPresentationStyle = .fullScreen
//                        self.present(controll, animated: true, completion: nil)
//                    }
                }
            }
        }
        
        rightBar = UIBarButtonItem(image:#imageLiteral(resourceName: "ic_notification") , style: UIBarButtonItem.Style.done, target: self, action: #selector(openNotification))
        self.navigationItem.setRightBarButton(rightBar, animated: true)
        rightBar.addBadge(number: 0)
        // Do any additional setup after loading the view.
    }

    func displayPriceingPlan() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calJob(flag: true)
        distanceDateTime = DistanceDateTime()
        
        callGetNotificationCount(url: baseURL+URLS.Notification_Count.rawValue) { (item) in
            if let item = item {
                if item.NotRead == 0 {
                    self.rightBar.removeBadge()
                } else {
                    self.rightBar.removeBadge()
                    self.rightBar.addBadge(number: item.NotRead)
                }
                
            } else {
                self.rightBar.removeBadge()
            }
        }
    }
    
    @objc func openNotification() {
        let vc = NotificationTableVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func calJob(flag : Bool) {
        let url = baseURL + URLS.Job_All.rawValue + "ShipperId=\(UserInfo.savedUser()!.Id)&JobStatus=NewJob"
        callGetAlljobList(url: url, flag: flag) { (data) in
            self.jobList.removeAll()
            if let data = data {
                self.mainJobList = data
                self.jobList = data
            }
            self.tableUpcoming.isHidden = self.jobList.isEmpty
            self.viewUpComing.isHidden = self.jobList.isEmpty
            self.setFilter(text: self.searchJob.text!)
        }
    }
    
}

extension DashboardVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableUpcoming {
            return jobList.count
        } else {
            return DashboardVC.truckTypeArray.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableUpcoming {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingCell") as! MyBookingCell
            let obj = jobList[indexPath.row]
            cell.lblServiceType.text = obj.TruckService
            cell.lblDate.text = "Job No: \(obj.JobNo)\nDate  : \(obj.PickupDate)"
            cell.lblType.text = obj.TruckType
            if let type = DashboardVC.truckTypeArray.filter({$0.Id == obj.TruckTypeId}).first {
                cell.lblType.text = type.Name
            }
            cell.lblPickupAddress.text = obj.PickUpAddress
            cell.lblDropAddress.text = obj.DropOffAddress
            cell.lblStatus.text = obj.JobStatus
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardCell") as! DashboardCell
            cell.lblTitle.text = DashboardVC.truckTypeArray[indexPath.row].Name
            cell.imgView.cornerRadius = cell.imgView.frame.size.height/2
    
            cell.imgView.image =  nil
            if let str = (imgBaseUrl+DashboardVC.truckTypeArray[indexPath.row].MaximumTonage).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlFragmentAllowed), let url = URL(string: str) {
                let resource = ImageResource(downloadURL: url, cacheKey: str)
                cell.imgView.kf.setImage(with: resource)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableUpcoming {
            let controll = MainBoard.instantiateViewController(identifier: "MyJobDetailBidVC") as! MyJobDetailBidVC
            controll.jobData = jobList[indexPath.row]
            self.navigationController?.pushViewController(controll, animated: true)
        } else {
            distanceDateTime.truckType = DashboardVC.truckTypeArray[indexPath.row]
            let controll = MainBoard.instantiateViewController(identifier: "SelectMapViewAddress") as! SelectMapViewAddress
            self.navigationController?.pushViewController(controll, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableUpcoming {
            return UITableView.automaticDimension
        } else {
            let height = (UIScreen.height - appDelegate.window!.safeAreaInsets.bottom - appDelegate.window!.windowScene!.statusBarManager!.statusBarFrame.height - appDelegate.window!.safeAreaInsets.top) / 6.0
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableUpcoming {
            return UITableView.automaticDimension
        } else {
            let height = (UIScreen.height - appDelegate.window!.safeAreaInsets.bottom - appDelegate.window!.windowScene!.statusBarManager!.statusBarFrame.height - appDelegate.window!.safeAreaInsets.top) / 6.0
            return height
        }
    }
}

extension DashboardVC : UISearchBarDelegate {
    
    func setFilter(text : String) {
        if text.trim.isEmpty {
            self.jobList = self.mainJobList
        } else {
            self.jobList = self.mainJobList.filter({$0.JobNo.contains(text)})
        }
        self.tableUpcoming.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.setFilter(text: self.searchJob.text!)
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.tableTruckType.isHidden = true
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
        }
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableTruckType.isHidden = false
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
        }
        self.setFilter(text: self.searchJob.text!)
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if searchBar.textInputMode?.primaryLanguage == nil //|| text.length > 1
        {
            return false
        }
        var str = ""
        if text == "" {
            str = String(searchBar.text!.dropLast())
        } else {
            str = searchBar.text! + text
        }
        self.setFilter(text: str)
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.setFilter(text: "")
    }
}

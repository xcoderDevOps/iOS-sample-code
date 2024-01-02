//
//  AvailableJobListVC.swift
//  CargoXpress
//
//  Created by infolabh on 15/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class AvailableJobListVC: UIViewController {

    var rightBar : UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchJob: UISearchBar!
    
    
    var jobList = [JobData]()
    var mainJobList = [JobData]()
    var timer : Timer?
    static var isRefresh = false
    var filterData : FilterData?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Available Jobs"
        
        leftDriverMenuButton()
        
        callGetUserData(url: baseURL+URLS.Carriers_ById.rawValue+"\(UserInfo.savedUser()!.Id)") { (info) in
            if let info = info {
                info.isFindService = appDelegate.isFindService
                info.isProfileFeeled = UserInfo.savedUser()!.isProfileFeeled
                info.save()
//                if !info.IsPlanActive {
//                    let controll = MainBoard.instantiateViewController(identifier: "PurchacePlanVC") as! PurchacePlanVC
//                    controll.modalPresentationStyle = .fullScreen
//                    self.present(controll, animated: true, completion: nil)
//                }
            }
        }
        
        rightBar = UIBarButtonItem(image:#imageLiteral(resourceName: "ic_notification") , style: UIBarButtonItem.Style.done, target: self, action: #selector(openNotification))
        let rightBarFil = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), style: UIBarButtonItem.Style.done, target: self, action: #selector(openFilterScreen))
        self.navigationItem.setRightBarButtonItems([rightBarFil, rightBar], animated: true)
        rightBar.addBadge(number: 0)
        // Do any additional setup after loading the view.
        jobListAPI(flag: true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(jobListAPI), userInfo: nil, repeats: true)
        if AvailableJobListVC.isRefresh {
            AvailableJobListVC.isRefresh = false
            jobListAPI(flag: true)
        }
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    @objc func jobListAPI(flag : Bool) {
        var url = baseURL + URLS.Job_All.rawValue + "JobStatus=NewJob&CarrierId=\(UserInfo.savedUser()!.Id)"
        if let data = self.filterData {
            var arr = [String]()
            if !data.pickupId.isEmpty {
                arr.append("PickUpShipperAddressId=\(data.pickupId)")
            }
            if !data.dropId.isEmpty {
                arr.append("DropOffShipperAddressId=\(data.dropId)")
            }
            if !data.serviceTypeId.isEmpty {
                arr.append("TruckServiceId=\(data.serviceTypeId)")
            }
            if !data.pickupDate.isEmpty {
                arr.append("PickupDate=\(data.pickupDate)")
            }
            if !data.startDate.isEmpty {
                arr.append("CarrierJobStartDate=\(data.startDate)")
            }
            if !data.endDate.isEmpty {
                arr.append("CarrierJobEndDate=\(data.endDate)")
            }
            if !data.IsJobWithIssues.isEmpty {
                arr.append("IsJobWithIssues=\(true)")
            }
            url = url + "&" + arr.joined(separator: "&")
        }
        callGetAlljobList(url: url, flag: flag) { (data) in
            self.jobList.removeAll()
            if let data = data {
                self.mainJobList = data
                self.jobList = data
            } else {
                //showAlert("No Jobs Found")
            }
            self.setFilter(text: self.searchJob.text!)
        }
    }
    
    @objc func openFilterScreen() {
        let controll = MainBoard.instantiateViewController(identifier: "JobFilterVC") as! JobFilterVC
        controll.applyFilterData = filterData
        controll.completionBlock = { (filter) -> Void in
            if let filter = filter {
                self.filterData = filter
            } else {
                self.filterData = nil
            }
            self.jobListAPI(flag: true)
        }
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    @objc func openNotification() {
        let vc = NotificationTableVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AvailableJobListVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingCell") as! MyBookingCell
        let obj = jobList[indexPath.row]
        cell.lblServiceType.text = obj.TruckService
        //cell.lblTonnahe.text = "\(obj.ActualTonage)"
        cell.lblDate.text = "Job No: \(obj.JobNo)\nDate  : \(obj.PickupDate)"
        cell.lblType.text = obj.TruckType
        if let type = DashboardVC.truckTypeArray.filter({$0.Id == obj.TruckTypeId}).first {
            cell.lblType.text = type.Name
        }
        cell.lblPickupAddress.text = obj.PickUpAddress
        cell.lblDropAddress.text = obj.DropOffAddress
        cell.lblStatus.text = obj.JobStatus
        cell.lblCreatedDate.text = "Job Created On: \(obj.CreatedDateStr)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if UserInfo.savedUser()!.IsProfileCompleted {
            let controll = DriverBoard.instantiateViewController(identifier: "AvailableJobDetailsVC") as! AvailableJobDetailsVC
            controll.jobData = jobList[indexPath.row]
            self.navigationController?.pushViewController(controll, animated: true)
        } else if !UserInfo.savedUser()!.isProfileFeeled {
            
            let controll =  DriverBoard.instantiateViewController(identifier: "CarrierEditProfileVC") as! CarrierEditProfileVC
            controll.completion = { () -> Void in
                if let info = UserInfo.savedUser() {
                    info.isProfileFeeled = true
                    info.save()
                }
            }
            self.present(controll, animated: true, completion: nil)
            
//            let controll = DriverBoard.instantiateViewController(identifier: "SubmitProfileVC") as! SubmitProfileVC
//            controll.completion = { () -> Void in
//
//            }
//            self.present(controll, animated: true, completion: nil)
        } else {
            showAlert("Carrier is not approve your profile yet. Please try after sometime")
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136.0
    }
}

extension AvailableJobListVC : UISearchBarDelegate {
    
    func setFilter(text : String) {
        if text.trim.isEmpty {
            self.jobList = self.mainJobList
        } else {
            self.jobList = self.mainJobList.filter({$0.JobNo.contains(text)})
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.setFilter(text: self.searchJob.text!)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
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

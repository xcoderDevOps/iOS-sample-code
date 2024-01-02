//
//  ReturnContainerVC.swift
//  CargoXpress
//
//  Created by infolabh on 24/08/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class ReturnContainerVC: UIViewController  {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var searchJob: UISearchBar!
    var mainJobList = [JobData]()
    var jobList = [JobData]()
    var timer : Timer?
    static var isRefresh = false
    var filterData : FilterData?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Return Container"
        leftDriverMenuButton()
        // Do any additional setup after loading the view.
        let rightBarFil = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), style: UIBarButtonItem.Style.done, target: self, action: #selector(openFilterScreen))
        self.navigationItem.setRightBarButton(rightBarFil, animated: true)
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
    
    @IBAction func segmentChangeCLK(_ sender: UISegmentedControl) {
        jobListAPI(flag: true)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        jobListAPI(flag: true)
        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(jobListAPI), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    @objc func jobListAPI(flag : Bool) {
        var status = "New"
        if segmentView.selectedSegmentIndex == 0 {
            status = "New"
        } else if segmentView.selectedSegmentIndex == 1 {
            status = "Ongoing"
        } else {
            status = "Completed"
        }
        var url = baseURL + URLS.Job_All.rawValue + "JobStatus=\(status)&CarrierId=\(UserInfo.savedUser()!.Id)&ShipperId=0"
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
}

extension ReturnContainerVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingCell") as! MyBookingCell
        let obj = jobList[indexPath.row]
        //cell.lblServiceType.text = obj.TruckService
        //cell.lblTonnahe.text = "\(obj.ActualTonage)"
        if let date = obj.CreatedDateStr.components(separatedBy: " ").first, !obj.CreatedDateStr.isEmpty {
            cell.lblDate.text = "Job No: \(obj.JobNo)\nDate  : \(date)"
        } else {
            cell.lblDate.text = "Job No: \(obj.JobNo)"
        }
        
        cell.lblType.text = obj.TruckType
        if let type = DashboardVC.truckTypeArray.filter({$0.Id == obj.TruckTypeId}).first {
            cell.lblType.text = type.Name
        }
        cell.lblStatus.text = obj.JobStatus
        cell.lblCreatedDate.text = "Job Created On: \(obj.CreatedDateStr)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controll = DriverBoard.instantiateViewController(withIdentifier: "ReturnContainerDetailVC") as! ReturnContainerDetailVC
        controll.jobData = jobList[indexPath.row]
        self.navigationController?.pushViewController(controll, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

extension ReturnContainerVC : UISearchBarDelegate {
    
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

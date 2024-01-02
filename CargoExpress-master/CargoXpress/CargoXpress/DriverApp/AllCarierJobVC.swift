//
//  AllCarierJobVC.swift
//  CargoXpress
//
//  Created by infolabh on 23/08/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class AllCarierJobVC: UIViewController  {

    var arrayUpcoming = [JobData]()
    var arrayAssigned = [JobData]()
    var arrayCompleted = [JobData]()
    var arrayJobs = [JobData]()
    
    
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchJob: UISearchBar!
    var jobList = [JobData]()
    
    static var isRefresh  = false
    var timer : Timer?
    var filterData : FilterData?
    override func viewDidLoad() {
        super.viewDidLoad()
        leftMenuButton()
        title = "All Jobs"
        calJob(flag: true)
        
        let rightBarFil = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), style: UIBarButtonItem.Style.done, target: self, action: #selector(openFilterScreen))
        self.navigationItem.setRightBarButton(rightBarFil, animated: true)
        // Do any additional setup after loading the view.
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
            self.calJob(flag: true)
        }
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    @objc func calJob(flag: Bool) {
        self.jobListAPI(flag: flag)
        
        var url = baseURL + URLS.Job_All.rawValue + "CarrierId=\(UserInfo.savedUser()!.Id)"
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
                self.jobList = data
            } else {
                //showAlert("No Jobs Found")
            }
            self.jobSeperation(text: self.searchJob.text!)
        }
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
            self.arrayUpcoming.removeAll()
            if let data = data {
                self.arrayUpcoming = data
            } else {
                //showAlert("No Jobs Found")
            }
            self.jobSeperation(text: self.searchJob.text!)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if MyBookingVC.isRefresh {
            MyBookingVC.isRefresh = false
            calJob(flag: true)
        }
        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(calJob), userInfo: nil, repeats: true)
    }
    
    func jobSeperation(text: String) {
        arrayAssigned.removeAll()
        arrayCompleted.removeAll()
        for obj in jobList {
            if let status = JobStatus(rawValue : obj.JobStatusId) {
                switch status {
                case .QuoteAccepted:
                    arrayAssigned.append(obj)
                    break
                case .JobStarted:
                    arrayAssigned.append(obj)
                    break
                case .ClearanceInProgress:
                    arrayAssigned.append(obj)
                    break
                case .TruckAssigned:
                    arrayAssigned.append(obj)
                    break
                case .TruckEnroute:
                    arrayAssigned.append(obj)
                    break
                case .ArrivedAtDestination:
                    arrayAssigned.append(obj)
                    break
                case .ArrivedAtDropOff:
                    arrayAssigned.append(obj)
                    break
                case .JobCompleted:
                    arrayCompleted.append(obj)
                    break
                case .Cancelled:
                    arrayCompleted.append(obj)
                    break
                case .QuoteRequest:
                    break
                case .QuoteGeneration:
                    break
                case .NewJobReturn:
                    break
                case .OngoingJobReturn:
                    break
                case .CompletedJobReturn:
                    break
                }
            } else {
                //arrayUpcoming.append(obj)
            }
        }
        arrayJobs.removeAll()
        switch segmentView.selectedSegmentIndex {
        case 0:
            arrayJobs = arrayUpcoming
            break
        case 1:
            arrayJobs = arrayAssigned
            break
        case 2:
            arrayJobs = arrayCompleted
            break
        default:
            break
        }
        if !text.isEmpty {
            arrayJobs = arrayJobs.filter({$0.JobNo.contains(text)})
        }
        self.tableView.reloadData()
    }
    
    @IBAction func tapToChangeSegment(_ sender: UISegmentedControl) {
        jobSeperation(text: searchJob.text!)
    }

}

extension AllCarierJobVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayJobs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingCell") as! MyBookingCell
        let obj = arrayJobs[indexPath.row]
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
        if segmentView.selectedSegmentIndex == 0 {
            if UserInfo.savedUser()!.IsProfileCompleted {
                let controll = DriverBoard.instantiateViewController(identifier: "AvailableJobDetailsVC") as! AvailableJobDetailsVC
                controll.jobData = arrayJobs[indexPath.row]
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
            } else {
                showAlert("Carrier is not approve your profile yet. Please try after sometime")
            }
        } else if segmentView.selectedSegmentIndex == 1 {
            let controll = DriverBoard.instantiateViewController(identifier: "MyWonBidVC") as! MyWonBidVC
            controll.jobData = arrayJobs[indexPath.row]
            self.navigationController?.pushViewController(controll, animated: true)
        } else {
            let controll = DriverBoard.instantiateViewController(identifier: "MyWonBidVC") as! MyWonBidVC
            controll.jobData = arrayJobs[indexPath.row]
            self.navigationController?.pushViewController(controll, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136.0
    }
}


extension AllCarierJobVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.jobSeperation(text: self.searchJob.text!)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.jobSeperation(text: self.searchJob.text!)
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
        self.jobSeperation(text: str)
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.jobSeperation(text: "")
    }
}

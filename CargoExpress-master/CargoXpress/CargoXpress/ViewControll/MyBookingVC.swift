//
//  MyBookingVC.swift
//  GoldClean
//
//  Created by infolabh on 18/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class MyBookingCell : UITableViewCell {
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblPickupAddress: UILabel!
    @IBOutlet weak var lblDropAddress: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblCreatedDate: UILabel!
}

class MyBookingVC: UIViewController {

    var arrayUpcoming = [JobData]()
    var arrayAssigned = [JobData]()
    var arrayCompleted = [JobData]()
    var arrayJobs = [JobData]()
    
    @IBOutlet weak var searchJob: UISearchBar!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var jobList = [JobData]()
    var filterData : FilterData?
    static var isRefresh  = false
    var timer : Timer?
    
    var rightBar : UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        leftMenuButton()
        calJob(flag: true)
        rightBar = UIBarButtonItem(image: UIImage(systemName: "slider.vertical.3"), style: UIBarButtonItem.Style.done, target: self, action: #selector(openFilterScreen))
        self.navigationItem.setRightBarButton(rightBar, animated: true)
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
        var url = baseURL + URLS.Job_All.rawValue + "ShipperId=\(UserInfo.savedUser()!.Id)"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if MyBookingVC.isRefresh {
            MyBookingVC.isRefresh = false
            calJob(flag: true)
        }
        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(calJob), userInfo: nil, repeats: true)
    }
    
    func jobSeperation(text:String) {
        arrayUpcoming.removeAll()
        arrayAssigned.removeAll()
        arrayCompleted.removeAll()
        for obj in jobList {
            if let status = JobStatus(rawValue : obj.JobStatusId) {
                switch status {
                case .QuoteRequest:
                    arrayUpcoming.append(obj)
                    break
                case .QuoteGeneration:
                    arrayUpcoming.append(obj)
                    break
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
                case .NewJobReturn:
                    break
                case .OngoingJobReturn:
                    break
                case .CompletedJobReturn:
                    break
                case .NewJobReturn:
                    break
                case .OngoingJobReturn:
                    break
                case .CompletedJobReturn:
                    break
                }
            } else {
                arrayUpcoming.append(obj)
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
        self.jobSeperation(text: self.searchJob.text!)
    }

}

extension MyBookingVC : UITableViewDelegate, UITableViewDataSource {
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
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controll = MainBoard.instantiateViewController(identifier: "JobPaymentVC") as! JobPaymentVC
//        controll.jobData = arrayJobs[indexPath.row]
//        controll.jobBidData = JobBidData()
//        self.navigationController?.pushViewController(controll, animated: true)
        
        let controll = MainBoard.instantiateViewController(identifier: "MyJobDetailBidVC") as! MyJobDetailBidVC
        controll.jobData = arrayJobs[indexPath.row]
        self.navigationController?.pushViewController(controll, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136.0
    }
}

extension MyBookingVC : UISearchBarDelegate {
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

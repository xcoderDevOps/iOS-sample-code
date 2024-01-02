//
//  MyWonBidListVC.swift
//  CargoXpress
//
//  Created by infolabh on 15/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class MyWonBidListVC: UIViewController {

    var jobList = [JobData]()
    @IBOutlet weak var tableView: UITableView!
    static var isRefresh = false
    var filterData : FilterData?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Won Bids"
        leftDriverMenuButton()
        jobListAPI()
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
            self.jobListAPI()
        }
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if MyWonBidListVC.isRefresh {
            MyWonBidListVC.isRefresh = false
            jobListAPI()
        }
    }
    
    func jobListAPI() {
        var url = baseURL + URLS.Job_All.rawValue + "CarrierId=\(UserInfo.savedUser()!.Id)&JobStatus=OngoingJob"
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
        callGetAlljobList(url: url, flag: true) { (data) in
            self.jobList.removeAll()
            if let data = data {
                self.jobList = data
            } else {
                showAlert("No Jobs Found")
            }
            self.tableView.reloadData()
        }
    }
}

extension MyWonBidListVC : UITableViewDelegate, UITableViewDataSource {
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
        let controll = DriverBoard.instantiateViewController(identifier: "MyWonBidVC") as! MyWonBidVC
        controll.jobData = jobList[indexPath.row]
        self.navigationController?.pushViewController(controll, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136.0
    }
}

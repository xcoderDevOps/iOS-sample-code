//
//  ManageContainerRoutVC.swift
//  CargoXpress
//
//  Created by infolabh on 24/08/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class ManageContainerRoutVC: UIViewController {

    @IBOutlet weak var lblStartAddress: UILabel!
    @IBOutlet weak var lblEndAddress: UILabel!
    @IBOutlet weak var lblChieldAddress: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var routeArray = [RouteDetailData]()
    var routeMasterData = [RouteData]()
    
    var jobId = 0
    var driverTruckId = 0
    
    var masterRootId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton(color: UIColor.white)
        title = "Manage Route"
        self.getJobRootData(driverTruckId)
        // Do any additional setup after loading the view.
    }

    func getJobRootData(_ id: Int) {
        callGetRootData(jobId: "\(id)") { (data) in //self.jobData.Id
            self.routeMasterData = data
            if let first = data.first {
                self.masterRootId = first.Id
                self.lblStartAddress.text = first.PickUpLocationName
                self.lblEndAddress.text = first.DropOffLocationName
                
                self.callGetRootDetailData(rootId: "\(first.Id)") { (detailData) in
                    self.routeArray = detailData
                }
            }
            else {
                showAlert("Track Data Not Available")
            }
        }
    }
    
    @IBAction func btnStartAddress(_ sender: Any) {
        _ = displayViewController(SLpopupViewAnimationType.topBottom, nibName: "PopupSearchLocationVC", blockOK: { (address) in
            appDelegate.window?.rootViewController?.dismissPopupViewController(.bottomTop)
            if let arr = address as? [String], let str = arr.last {
                self.lblStartAddress.text = str
            }
            
        }, blockCancel: {
            appDelegate.window?.rootViewController?.dismissPopupViewController(.bottomTop)
        }, objData: nil)
    }
    
    @IBAction func btnEndAddress(_ sender: Any) {
        _ = displayViewController(SLpopupViewAnimationType.topBottom, nibName: "PopupSearchLocationVC", blockOK: { (address) in
            appDelegate.window?.rootViewController?.dismissPopupViewController(.bottomTop)
            if  let arr = address as? [String], let str = arr.last {
                self.lblEndAddress.text = str
            }
        }, blockCancel: {
            appDelegate.window?.rootViewController?.dismissPopupViewController(.bottomTop)
        }, objData: nil)
    }
    
    @IBAction func btnChieldAddress(_ sender: Any) {
        _ = displayViewController(SLpopupViewAnimationType.topBottom, nibName: "PopupSearchLocationVC", blockOK: { (address) in
            appDelegate.window?.rootViewController?.dismissPopupViewController(.bottomTop)
            if let arr = address as? [String], let str = arr.last {
                self.lblChieldAddress.text = str
            }
        }, blockCancel: {
            appDelegate.window?.rootViewController?.dismissPopupViewController(.bottomTop)
        }, objData: nil)
    }
    
    @IBAction func btnSubmitCLK(_ sender: LetsButton) {
        if self.lblStartAddress.text! == "Select address" || self.lblEndAddress.text! == "Select address" {
            showAlert("Please select both address")
            return
        }
        let param = ["Id": self.masterRootId,
                     "JobId":self.jobId,
                     "JobTruckDriverId":self.driverTruckId,
                     "PickUpLocationName":self.lblStartAddress.text!,
                     "DropOffLocationName":self.lblEndAddress.text! ] as [String : AnyObject]
        self.callAddContainerRoute(url: baseURL+URLS.RouteMaster_Upsert.rawValue, param) { (data) in
            if let data = data {
                self.routeMasterData.append(data)
            }
        }
    }
    
    @IBAction func btnAddChieldCLK(_ sender: LetsButton) {
        if routeMasterData.isEmpty {
            showAlert("Add Main Rout Source and Destination first")
            return
        } else if let first = routeMasterData.first {
            if  self.lblChieldAddress.text! == "Select address" {
                showAlert("Please select chield route address")
                return
            }
            let param = ["Id": 0,
                         "RouteMasterId": first.Id,
                         "LocationName": self.lblChieldAddress.text!
                ] as [String : AnyObject]
            self.callAddChieldRoute(url: baseURL+URLS.RouteChild_Upsert.rawValue, param) { (data) in
                if let data = data {
                    self.routeArray.append(data)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ManageContainerRoutVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackJobCell") as! TrackJobCell
        cell.lblTitle.text = self.routeArray[indexPath.row].LocationName
        return cell
    }
}

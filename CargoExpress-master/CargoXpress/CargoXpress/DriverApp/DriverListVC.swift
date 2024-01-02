//
//  DriverListVC.swift
//  CargoXpress
//
//  Created by infolabh on 09/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class DriverListCell : UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
}

class DriverListVC: UIViewController {

    var blockAssignDrtiver : ((_ data:JobData)->())?
    var blockAssignDrtiverAdd : ((_ data:DriverData)->())?
    @IBOutlet weak var tableView: UITableView!
    
    var isFromWon = false
    var isFromWonAdd = false
    var jobId = 0
    var driverList = [DriverData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromWon {
            title = "Assign Driver"
            backButton(color: UIColor.white)
        } else if isFromWonAdd {
            title = "Add Driver"
            backButton(color: UIColor.white)
        } else {
            leftDriverMenuButton()
        }
        callAPI()
        // Do any additional setup after loading the view.
    }
    
    func callAPI() {
        callGetDriverList(url: baseURL+URLS.Drivers_All.rawValue+"\(UserInfo.savedUser()!.Id)") { (data) in
            self.driverList = data
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addDriverCLK(_ sender: LetsButton) {
        
        _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupAddDriverVC", blockOK: { (obj) in
            dismissPopUp()
            self.callAPI()
        }, blockCancel: {
            dismissPopUp()
        }, objData: nil)
    }
    

}


extension DriverListVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.driverList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverListCell") as! DriverListCell
        let driver = self.driverList[indexPath.row]
        cell.lblName.text = driver.FullName
        cell.lblMobile.text = driver.PhoneNumberStr
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromWon {
            assignDriver(d_id: self.driverList[indexPath.row].Id)
        } else if isFromWonAdd {
            self.navigationController?.popViewController(animated: true)
            if self.blockAssignDrtiverAdd != nil {
                self.blockAssignDrtiverAdd!(self.driverList[indexPath.row])
            }
        }
    }
    
    func assignDriver(d_id : Int) {
        let url = baseURL+URLS.Job_AssignDriver.rawValue
        let param = ["Id":jobId, "DriverId":d_id] as [String : Any]
        calChangeJobStatus(url: url, param) { (data) in
            if let data = data {
                self.navigationController?.popViewController(animated: true)
                DispatchQueue.main.async {
                    if self.blockAssignDrtiver != nil {
                       self.blockAssignDrtiver!(data)
                    }
                }
            }
        }
    }
}

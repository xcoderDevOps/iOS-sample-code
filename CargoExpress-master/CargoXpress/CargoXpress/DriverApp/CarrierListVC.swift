//
//  DriverListVC.swift
//  CargoXpress
//
//  Created by infolabh on 09/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class CarrierListCell : UITableViewCell {
    @IBOutlet weak var lblNamePlate: UILabel!
    @IBOutlet weak var viewTruckStatus: LetsView!
    @IBOutlet weak var lblTruckStatus: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var btnAddFualTank: LetsButton!
    @IBOutlet weak var btnviewFualData: LetsButton!
    @IBOutlet weak var btnviewStandAloneLoc: LetsButton!
    
    @IBOutlet weak var stackBtns: UIStackView!
    
    var blockAddFualTank: (()->())?
    var blockFualDataTank: (()->())?
    var blockViewStandAloneTank: (()->())?
    
    @IBAction func btnAddFualTankCLK(_ sender: LetsButton) {
        blockAddFualTank?()
    }
    
    @IBAction func btnViewFualDataCLK(_ sender: LetsButton) {
        blockFualDataTank?()
    }
    
    @IBAction func btnViewStandAloneCLK(_ sender: LetsButton) {
        blockViewStandAloneTank?()
    }
    
}

class CarrierListVC : UIViewController {

    var blockAssignCareer : ((_ data:JobData)->())?
    var blockAssignCareerAdd : ((_ data:TruckData)->())?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewAllOnMap: UIView!
    
    var isFromWon = false
    var isFromWonAdd = false
    var jobId = 0
    var truckArray = [TruckData]()
    
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewAllOnMap.isHidden = true
        if isFromWon {
            title = "Assign Truck"
            backButton(color: UIColor.white)
        } else if isFromWonAdd {
            title = "Add Truck"
            backButton(color: UIColor.white)
        } else {
            leftDriverMenuButton()
            title = "Manage Truck"
            
        }
        callAPI(flag: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.isFromWon && !self.isFromWonAdd {
            timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(callAPI(flag:)), userInfo: nil, repeats: true)
            timer.fire()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
    }
    
    @objc func callAPI(flag:Bool) {
        callGetTruckList(flag) { (data) in
            if self.isFromWon || self.isFromWonAdd {
                self.truckArray = data.filter({$0.IsActive})
            } else {
                self.truckArray = data
                self.viewAllOnMap.isHidden = data.isEmpty
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func btnViewAllTruckListCLK(_ sender: LetsButton) {
        let controll = DriverBoard.instantiateViewController(identifier: "TruckAllMapScreenVC") as! TruckAllMapScreenVC
        controll.truckArray = self.truckArray
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    @IBAction func addCarrierCLK(_ sender: LetsButton) {
        _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupAddTruckVC", blockOK: { (obj) in
            dismissPopUp()
            self.callAPI(flag: true)
        }, blockCancel: {
            dismissPopUp()
        }, objData: nil)
        
    }
}


extension CarrierListVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.truckArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarrierListCell") as! CarrierListCell
        let obj = self.truckArray[indexPath.row]
        cell.lblNamePlate.text = obj.PlateNumber
        var arr = [String]()
        if !obj.Speed.isEmpty {
            arr.append("Speed:\(obj.Speed)")
        }
        if !obj.FuelLevel.isEmpty {
            arr.append("Fuel Level:\(obj.FuelLevel)")
        }
        if !obj.CompanyName.isEmpty {
            arr.append("Company:\(obj.CompanyName)")
        }
        
        cell.lblType.text = arr.joined(separator: ", ")
        if isFromWon || isFromWonAdd {
            cell.btnAddFualTank.isHidden = true
            cell.btnviewFualData.isHidden = true
            cell.btnviewStandAloneLoc.isHidden = true
            cell.stackBtns.isHidden = true
            cell.viewTruckStatus.isHidden = true
        } else {
            cell.btnAddFualTank.isHidden = false
            cell.btnviewFualData.isHidden = false
            cell.btnviewStandAloneLoc.isHidden = false
            cell.stackBtns.isHidden = false
            cell.viewTruckStatus.isHidden = false
        }
        
        if obj.IsMoving == 1 {
            cell.lblTruckStatus.text = "Moving"
            cell.viewTruckStatus.backgroundColor = UIColor.systemGreen
        } else if obj.IsMoving == 2 {
            cell.lblTruckStatus.text = "Stable"
            cell.viewTruckStatus.backgroundColor = UIColor.systemRed
        } else {
            cell.lblTruckStatus.text = "New"
            cell.viewTruckStatus.backgroundColor = UIColor.systemYellow
        }
        
        cell.blockAddFualTank = { () -> Void in
            _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupAddFuelTankVC", blockOK: { (data) in
                dismissPopUp()
            }, blockCancel: {
                dismissPopUp()
            }, objData: "\(obj.Id)" as AnyObject)
        }
        cell.blockFualDataTank = { () -> Void in
            let controll = DriverBoard.instantiateViewController(identifier: "TruckFualChartDataVC") as! TruckFualChartDataVC
            controll.truckData = self.truckArray[indexPath.row]
            self.navigationController?.pushViewController(controll, animated: true)
        }
        cell.blockViewStandAloneTank = { () -> Void in
            let controll = DriverBoard.instantiateViewController(identifier: "TruckStandAloneLocationVC") as! TruckStandAloneLocationVC
            controll.truckData = self.truckArray[indexPath.row]
            self.navigationController?.pushViewController(controll, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromWon {
            assignTruck(d_id: self.truckArray[indexPath.row].Id)
        } else if isFromWonAdd {
            self.navigationController?.popViewController(animated: true)
            if blockAssignCareerAdd != nil {
                blockAssignCareerAdd!(self.truckArray[indexPath.row])
            }
        } else {
            _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupAddTruckVC", blockOK: { (obj) in
                dismissPopUp()
                self.callAPI(flag: true)
            }, blockCancel: {
                dismissPopUp()
            }, objData: self.truckArray[indexPath.row] as AnyObject)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func assignTruck(d_id : Int) {
        let url = baseURL+URLS.Job_AssignTruck.rawValue
        let param = ["Id":jobId, "TruckId":d_id] as [String : Any]
        calChangeJobStatus(url: url, param) { (data) in
            if let data = data {
                self.navigationController?.popViewController(animated: true)
                DispatchQueue.main.async {
                    if self.blockAssignCareer != nil {
                       self.blockAssignCareer!(data)
                    }
                }
            }
        }
    }
}

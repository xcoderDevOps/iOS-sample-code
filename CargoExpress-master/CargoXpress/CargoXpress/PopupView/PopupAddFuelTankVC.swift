//
//  PopupAddFuelTankVC.swift
//  CargoXpress
//
//  Created by Alpesh Desai on 12/12/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class FuelTankCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    var blockDelete : (()->())?
    
    @IBAction func btnDeleteTypeCLK(_ sender: UIButton) {
        self.blockDelete?()
    }
}

class PopupAddFuelTankVC: MyPopupController {

    var fualArray = [LocationTypeData]()
    var fualType : LocationTypeData?
    var addedFuals = [FualTypeData]()
    
    @IBOutlet weak var txtType: LetsFloatField!
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    @IBOutlet weak var tableType: UITableView!
    
    var truckId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = objData as? String {
            truckId = data
        }
        
        
        let url = baseURL + URLS.FuelMaster_All.rawValue
        callGetFualTypeDataAPI(url: url) { (data) in
            self.fualArray = data
        }
        heightCons.constant = 0.0
        
        callGetTRUCKFualDataAPI(url: baseURL + URLS.TruckFuel_All.rawValue + "\(truckId)") { (data) in
            self.addedFuals = data
            self.heightCons.constant = (45.0 * CGFloat(data.count)) + 30.0
            self.tableType.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnFualTypeCLK(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: fualArray.map({$0.Name})) { (str, index) in
            self.txtType.text = str
            self.fualType = self.fualArray[index]
        }
    }
    

    @IBAction func btnSubmitCLK(_ sender: UIButton) {
        if let type = fualType {
            let param = ["TruckId": truckId.ns.integerValue,
                         "FuelMasterId": type.Id,
                         "Formula":"test"] as [String : Any]
            let url = baseURL+URLS.TruckFuel_Upsert.rawValue
            callUpsertFualTruck(url: url, param) { (data) in
                if let data = data {
                    showAlert("Fuel tank added successfully")
                    self.addedFuals.append(data)
                    self.heightCons.constant = (45.0 * CGFloat(self.addedFuals.count)) + 30.0
                    self.tableType.reloadData()
                }
            }
        } else {
            showAlert("Please select fuel tank")
        }
        if pressOK != nil {
            self.pressOK!(nil)
        }
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        if pressCancel != nil {
            self.pressCancel!()
        }
    }

}


extension PopupAddFuelTankVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addedFuals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FuelTankCell") as! FuelTankCell
        cell.lblTitle.text = addedFuals[indexPath.row].FuelType
        cell.blockDelete = { () -> Void in
            self.callDeleteTruckTypeData(id: "\(self.addedFuals[indexPath.row].Id)") { (str) in
                if let str = str, str == "true" {
                    self.addedFuals.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
}

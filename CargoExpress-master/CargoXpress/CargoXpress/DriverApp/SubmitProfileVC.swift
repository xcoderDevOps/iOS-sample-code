//
//  SubmitProfileVC.swift
//  CargoXpress
//
//  Created by infolabh on 20/06/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class SubmitProfileCell : UITableViewCell {
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
}

class SubmitProfileVC: UIViewController {
    
    @IBOutlet weak var tableCountry: UITableView!
    @IBOutlet weak var tableService: UITableView!
    var countryList = [CountryData]()
    var serviceList = [ServiceTypeData]()
    
    var completion : (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callGetCountryList { (data) in
            self.countryList = data
            self.tableCountry.reloadData()
        }
        callGetServiceTypeList(id: 0) { (data) in
            self.serviceList = data
            self.tableService.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    var cIndex = 0
    var sIndex = 0
    
    @IBAction func btnSubmitProfileCLK(_ sender: LetsButton) {
        let countrys = countryList.filter({$0.isSelect})
        if countrys.isEmpty {
            showAlert("Please select your preferred areas")
            return
        }
        let services = serviceList.filter({$0.isSelect})
        if services.isEmpty {
            showAlert("Please select your preferred services type")
            return
        }
        
        cIndex = 0
        sIndex = 0
        self.insertCountry(countrys: countrys)
        
    }
    
    func insertCountry(countrys: [CountryData]) {
        if cIndex == countrys.count {
                let services = serviceList.filter({$0.isSelect})
                insertService(services: services)
                
        } else {
            let param = ["CarrierId": UserInfo.savedUser()!.Id,
                         "CountryId": countrys[cIndex].Id]
            self.callAddService(url: baseURL + URLS.CarrierDestinations_Upsert.rawValue, param) {
                self.cIndex = self.cIndex + 1
                self.insertCountry(countrys: countrys)
            }
        }
        
    }
    
    
    func insertService(services: [ServiceTypeData]) {
        if sIndex == services.count {
            dismiss(animated: true) {
                if self.completion != nil {
                    self.completion!()
                }
                showAlert("Location and Service selected Successfully")
            }
        } else {
            let param = ["CarrierId": UserInfo.savedUser()!.Id,
                         "TruckServiceId": services[sIndex].Id]
            self.callAddService(url: baseURL + URLS.CarrierTruckServices_Upsert.rawValue, param) {
                self.sIndex = self.sIndex + 1
                self.insertService(services: services)
            }
        }
    }
    
    @IBAction func btnDismissCLK(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

extension SubmitProfileVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableCountry {
            return self.countryList.count
        } else {
            return self.serviceList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableCountry {
            let cell = tableView.dequeueReusableCell(withIdentifier: "country") as! SubmitProfileCell
            let obj = self.countryList[indexPath.row]
            cell.lblTitle.text = obj.Name
            cell.imgCheckBox.image = obj.isSelect ? #imageLiteral(resourceName: "checkBox") : #imageLiteral(resourceName: "uncheckBox")
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "service") as! SubmitProfileCell
            let obj = self.serviceList[indexPath.row]
            cell.lblTitle.text = obj.Name
            cell.imgCheckBox.image = obj.isSelect ? #imageLiteral(resourceName: "checkBox") : #imageLiteral(resourceName: "uncheckBox")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableCountry {
            self.countryList[indexPath.row].isSelect = !self.countryList[indexPath.row].isSelect
        } else {
            self.serviceList[indexPath.row].isSelect = !self.serviceList[indexPath.row].isSelect
        }
        tableView.reloadData()
    }
    
}

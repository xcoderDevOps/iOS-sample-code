//
//  PurchacePlanVC.swift
//  CargoXpress
//
//  Created by infolabh on 27/06/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class PurchacePlanCell : UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblIntDay: UILabel!
    @IBOutlet weak var lblServiceVa: UILabel!
    @IBOutlet weak var lblAddServiceP: UILabel!
    @IBOutlet weak var lblAdvPay: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
}

class PurchacePlanVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var plans = [PriceData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Plan Purchase"
        backButton(color: UIColor.white)
        
        self.callGetPricePlan(userType: appDelegate.isFindService ? "3" : "2") { (data) in
            self.plans = data
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    func selectPlan(data: PriceData) {
        let param = ["CarrierId": UserInfo.savedUser()!.Id,
                     "MasterPricingPlanId":data.Id,
                     "UserType":appDelegate.isFindService ? 3 : 2]  as [String : Any]
        print(param)
        print(baseURL+URLS.CarrierPricingPlan_Upsert.rawValue)
        self.callInertPlan(url: baseURL+URLS.CarrierPricingPlan_Upsert.rawValue, param: param) { (data) in
            if data != nil {
                if let info = UserInfo.savedUser() {
                    info.IsPlanActive = true
                    info.save()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}

extension PurchacePlanVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchacePlanCell") as! PurchacePlanCell
        let obj = plans[indexPath.row]
        cell.lblTitle.text = obj.PlanName
        if !obj.Description.isEmpty {
            cell.lblDesc.text = obj.Description
        }
        if !obj.TotalNoOfInterServices.isEmpty{
            cell.lblIntDay.text = obj.TotalNoOfInterServices
        }
        if !obj.TimeLimit.isEmpty{
            cell.lblServiceVa.text = obj.TimeLimit + " Days"
        }
        if !obj.AdditionalServicePrice.isEmpty{
            cell.lblAddServiceP.text = "$\(obj.AdditionalServicePrice)"
        }
        if !obj.AdvPayPerc.isEmpty{
            cell.lblAdvPay.text = "\(obj.AdvPayPerc)%"
        }
        cell.lblPrice.text = "$\(obj.Price)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = plans[indexPath.row]
        self.selectPlan(data: obj)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

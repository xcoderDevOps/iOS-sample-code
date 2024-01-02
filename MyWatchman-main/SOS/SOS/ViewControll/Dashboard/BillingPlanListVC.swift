//
//  BillingPlanListVC.swift
//  SOS
//
//  Created by Alpesh Desai on 01/01/21.
//

import UIKit

class BillingPlanCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAmout: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var bgView: UIView!
}

class BillingPlanListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnTC: UIButton!
    var arrayData = [PlanListData]()
    var selectedPlan : PlanListData?
    var rightBar : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Plan"
        rightBar = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.done, target: self, action: #selector(logoutFunc))
        self.navigationItem.setRightBarButton(rightBar, animated: true)
        callGetPlanData { (data) in
            self.arrayData = data
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func logoutFunc() {
        UserInfo.clearUser()
        appDelegate.gotToSigninView()
    }
    
    @IBAction func btnAcceptTCCLK(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnChoosePlanCLK(_ sender: UIButton) {
        if let plan = self.selectedPlan, btnTC.isSelected {
            
            _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupPlanDurationVC", blockOK: { (obj) in
                if let id = obj as? Int {
                    self.callGetPlanDetail(url: baseURL+URLS.GetPlanDetails.rawValue+"\(plan.Id)&SettingId=\(id)") { (data) in
                        if let data = data {
                            let controll = MainBoard.instantiateViewController(identifier: "CapturePaymentVC") as! CapturePaymentVC
                            controll.selectedPlan = data
                            self.navigationController?.pushViewController(controll, animated: true)
                        }
                    }
                }
                dismissPopUp()
            }, blockCancel: {
                dismissPopUp()
            }, objData: selectedPlan as AnyObject)
        } else {
            showAlert("Please agree on Terms & Condition")
        }
    }
    

}


extension BillingPlanListVC : UITableViewDelegate,  UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillingPlanCell") as! BillingPlanCell
        let obj = self.arrayData[indexPath.row]
        if let plan = selectedPlan {
            cell.bgView.backgroundColor = plan.Id == obj.Id ?  #colorLiteral(red: 0.2389999926, green: 0.6549999714, blue: 0.97299999, alpha: 1) : UIColor.white
            cell.lblTitle.textColor = plan.Id == obj.Id ?  UIColor.white : UIColor.black
            cell.lblAmout.textColor = plan.Id == obj.Id ?  UIColor.white : UIColor.black
            cell.lblMonth.textColor = plan.Id == obj.Id ?  UIColor.white : UIColor.black
        }
        cell.lblTitle.text = obj.PlanCategory
        cell.lblAmout.text = "$\(obj.Price)"
        cell.lblMonth.text = "\(obj.PlanDurationMonth) Month Security"
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlan = arrayData[indexPath.row]
        tableView.reloadData()
    }
}

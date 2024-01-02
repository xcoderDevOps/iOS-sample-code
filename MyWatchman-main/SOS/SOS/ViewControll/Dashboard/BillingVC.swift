//
//  BillingVC.swift
//  SOS
//
//  Created by Alpesh Desai on 28/12/20.
//

import UIKit
import SafariServices

class BillingHisCell : UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
}

class BillingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAddressCount :UILabel!
    @IBOutlet weak var lblSubUsers: UILabel!
    @IBOutlet weak var lblPlanType: UILabel!
    @IBOutlet weak var btnCancel :LetsButton!
    
    var arrayBilling = [BillingData]() {
        didSet {
            self.btnCancel.isHidden = arrayBilling.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton()
        title = "Billing"
        btnCancel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
        callGetBillingHistory { (data) in
            self.arrayBilling = data
            self.tableView.reloadData()
        }
    }
    
    func setupData() {
        if let info = UserInfo.savedUser() {
            lblPlanType.text = info.PlanName
            lblPlan.text = "Monthly"
            lblSubUsers.text = info.MaxSubAccount
            lblPrice.text = "$\(info.PlanPrice)"
            lblDate.text = info.PlanExpiryDate
            lblAddressCount.text = "\(info.AddressCount)"
        }
    }
    
    @IBAction func btnCancelPlanCLK(_ sender: LetsButton) {
        alertShow(self, title: "", message: "Are you sure you want to Cancel Plan?", okStr: "Yes", cancelStr: "No") {
            self.callCancelPanByCustomer { (info) in
                if let info = info {
                    UserInfo.clearUser()
                    appDelegate.gotToSigninView()
                }
            }
        } cancelClick: {}
    }
    
    @IBAction func btnUpdatePlanCLK(_ sender: LetsButton) {
//        let url = URL(string: "https://payment.my-watchman.com/payment.aspx?mobile=\(UserInfo.savedUser()!.Mobile)")
//        let svc = SFSafariViewController(url: url!)
//        svc.view.tintColor = UIColor.systemBlue
//        self.present(svc, animated: true, completion: nil)
        
        let controll = MainBoard.instantiateViewController(withIdentifier: "PaymentOptionVC") as! PaymentOptionVC
        self.navigationController?.pushViewController(controll, animated: true)
        
        
//        _ = displayViewController(SLpopupViewAnimationType.bottomTop, nibName: "PopupSelectPlanVC", blockOK: { (obj) in
//            if let data = obj as? PlanData {
//                self.callGetPlanDetail(url: baseURL+URLS.GetPlanDetails.rawValue+"\(data.planId)&SettingId=\(data.durationId)") { (data) in
//                    if let data = data {
//                        let controll = MainBoard.instantiateViewController(identifier: "CapturePaymentVC") as! CapturePaymentVC
//                        controll.selectedPlan = data
//                        self.navigationController?.pushViewController(controll, animated: true)
//                    }
//                }
//            }
//            appDelegate.window?.rootViewController?.dismissPopupViewController(SLpopupViewAnimationType.topBottom)
//        }, blockCancel: {
//            appDelegate.window?.rootViewController?.dismissPopupViewController(SLpopupViewAnimationType.topBottom)
//        }, objData: 0 as AnyObject)
    }

}


extension BillingVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayBilling.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BillingHisCell") as! BillingHisCell
        let obj = self.arrayBilling[indexPath.row]
        cell.lblDate.text = obj.TransactionStartDate
        cell.lblType.text = obj.PlanName
        cell.lblAmount.text = "$\(obj.TransactionAmount)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

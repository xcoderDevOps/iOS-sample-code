//
//  PopupChangeBidVC.swift
//  CargoXpress
//
//  Created by infolabh on 09/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import GMStepper

class PopupChangeBidVC: MyPopupController {

    @IBOutlet var lblTBid : UILabel!
    @IBOutlet var txtBid : LetsTextField!
    @IBOutlet var stepper : GMStepper!
    
    @IBOutlet var switchV : UISwitch!
    @IBOutlet var segmentControll : UISegmentedControl!
    @IBOutlet var txtPercentage : UITextField!
    @IBOutlet var txtDays : UITextField!
    @IBOutlet var tableView : UITableView!
    
    @IBOutlet var lblTitle : UILabel!
    
    @IBOutlet var lblFillBid : UILabel!
    @IBOutlet var btnAddFinance : UIButton!
    
    
    struct FinanceData {
        var type = ""
        var percent = ""
        var day = ""
    }
    
    var arrayFinance = [JobBidFinanceData]()
    var bidId = 0
    var jobId = 0
    var currency = ""
    var bidData :JobBidData?
    
    override func viewDidLoad() {
          super.viewDidLoad()
        lblTitle.text = "Post Your Bid"
        if let bid = objData as? JobBidData {
            bidData = bid
            txtBid.text = "\(bid.Price)"
            stepper.value = Double(bid.JobCompletionDays)
            lblTitle.text = "Change Your Bid"
            bidId = bid.Id
            callFinanceListAPI()
            self.switchV.setOn(bid.IsFinance, animated: true)
            self.tableView.isHidden = !switchV.isOn
            lblFillBid.isHidden = true
            btnAddFinance.isHidden = false
            jobId = bid.JobId
            self.currency = bid.Currency
        } else if let jobData = objData as? JobData {
            self.jobId = jobData.Id
            self.currency = jobData.Currency
            lblFillBid.isHidden = false
            btnAddFinance.isHidden = true
        }
        lblTBid.text = "Enter your bid in \(currency)"
        txtBid.placeholder = "Enter Amount in \(currency)"
        txtDays.isHidden = true
          // Do any additional setup after loading the view.
      }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func callFinanceListAPI() {
        let url = baseURL+URLS.JobBidsFinance_All.rawValue+"\(bidId)"
        callGetFinanceBid(url:url) { (data) in
            self.arrayFinance = data
            if !self.switchV.isOn {
                self.tableView.isHidden = self.arrayFinance.isEmpty
                self.switchV.setOn(true, animated: true)
            }
            
            self.tableView.reloadData()
        }
    }

      @IBAction func btnOkCLK(_ sender: UIButton) {
        if txtBid.text!.isEmpty {
            showAlert("Please fill all the field")
            return
        }
        if txtBid.text!.ns.doubleValue == 0.0  {
            showAlert("Bid amound should not be $0")
            return
        }
        
        var param = [   "JobId": self.jobId,
                        "JobCompletionDays": Int(stepper.value),
                        "CarrierId": UserInfo.savedUser()!.Id,
                        "Price": txtBid.text!.ns.doubleValue,
                        "Description":"",
                        "IsFinance": switchV.isOn ? "true":"false"] as [String : Any]
        if self.bidId > 0 {
            param["Id"] = self.bidId as Any
        }
        print(param)
        self.callPostBid(url: baseURL+URLS.PostBid.rawValue, param) { (data) in
            if data != nil {
                self.bidData = data
                self.bidId = self.bidData!.Id
                AvailableJobListVC.isRefresh = true
                self.lblFillBid.isHidden = true
                self.btnAddFinance.isHidden = false
            }
        }
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        if pressOK != nil {
            self.pressOK!(bidData as AnyObject)
        }
    }
    
    @IBAction func btnSWitchOnOff(_ sender: UISwitch) {
        self.arrayFinance.removeAll()
        self.txtDays.text = ""
        self.txtPercentage.text = ""
        self.tableView.isHidden = !sender.isOn
        txtDays.isHidden = true
    }
    
    @IBAction func btnSegmentChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            txtDays.isHidden = true
        } else {
            txtDays.isHidden = false
        }
        UIView.animate(withDuration: 0.33) {
            self.view.layoutSubviews()
        }
    }
    
    @IBAction func btnAddFinanceCLK(_ sender: UIButton) {
        let tot = arrayFinance.compactMap({$0.Percentage}).reduce(0, +)
        if txtPercentage.text!.isEmpty {
            showAlert(popUpMessage.emptyString.rawValue)
            return
        }
        let per = txtPercentage.text!.ns.integerValue
        let day = txtDays.text!.ns.integerValue
        if per <= (100-tot) {
            var type = ""
            if segmentControll.selectedSegmentIndex == 0 {
                
                if !txtPercentage.text!.isEmpty {
                    type = "Pre Payment"
                }
            } else {
                if !txtPercentage.text!.isEmpty && !txtDays.text!.isEmpty {
                    type = "After Delivert"
                }
            }
            if !type.isEmpty {
                let param = ["JobBidId":bidId,
                             "FinanceType":type,
                             "Percentage":per,
                             "Days":day] as [String : Any]
                callAddJobFinance(param) { (data) in
                    if let data = data {
                        self.arrayFinance.append(data)
                        self.tableView.reloadData()
                    }
                }
            } else {
                showAlert(popUpMessage.emptyString.rawValue)
            }
        } else {
            showAlert("Total % should not be more than 100%")
        }
    }
}

extension PopupChangeBidVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayFinance.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopupChangeBidCell") as! PopupChangeBidCell
        let obj = arrayFinance[indexPath.row]
        cell.lblType.text = obj.FinanceType
        cell.lblPerce.text = "\(obj.Percentage)%"
        cell.lblDay.text = "\(obj.Days)"
        cell.blockDelete = { () -> Void in
            self.callDeleteFinanceData(id: "\(obj.Id)") { (str) in
                if str == "Deleted Successfully" {
                    self.arrayFinance.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

class PopupChangeBidCell : UITableViewCell {
    @IBOutlet weak var lblType : UILabel!
    @IBOutlet weak var lblPerce : UILabel!
    @IBOutlet weak var lblDay : UILabel!
    @IBOutlet weak var btnDelete : UIButton!
    
    var blockDelete:(()->())?
    
    @IBAction func btnTapToDeleteCLK(_ sender: UIButton) {
        if blockDelete != nil {
            blockDelete!()
        }
    }
}

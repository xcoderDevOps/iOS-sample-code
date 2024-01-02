//
//  PopupSelectBidVCViewController.swift
//  CargoXpress
//
//  Created by infolabh on 01/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class PopupSelectBidVC: MyPopupController {
    
    var bidData = JobBidData()
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    @IBOutlet weak var stackFincance: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    var arrayFinance = [JobBidFinanceData]()
    
    var bidId = 0
    var isFinance = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let data = objData as? JobBidData {
            bidData = data
            lblName.text = bidData.CarrierName
            lblPrice.text = "[Price : \(bidData.Price)$]"
            bidId = data.Id
            isFinance = data.IsFinance
            self.tableView.isHidden = true
            callFinanceListAPI()
            //lblDesc.text = bidData.Description
        }
        heightLayout.constant = 0.0
        // Do any additional setup after loading the view.
    }
    
    func callFinanceListAPI() {
        let url = baseURL+URLS.JobBidsFinance_All.rawValue+"\(bidId)"
        callGetFinanceBid(url:url) { (data) in
            self.arrayFinance = data
            self.stackFincance.isHidden = self.arrayFinance.isEmpty
            self.tableView.isHidden = !self.isFinance
            self.tableView.isHidden = self.arrayFinance.isEmpty
            self.tableView.reloadData()
            if !self.arrayFinance.isEmpty {
                self.heightLayout.constant = 50.0 + (CGFloat(self.arrayFinance.count)*44.0)
            }
            UIView.animate(withDuration: 0.33) {
                self.view.layoutSubviews()
            }
        }
    }
    
    
    @IBAction func btnDismissPopupCLK(_ sender: UIButton) {
        dismissPopUp()
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        if pressCancel != nil {
            pressCancel!()
        }
    }
  
    @IBAction func btnOkCLK(_ sender: UIButton) {
        if pressOK != nil {
            pressOK!(nil)
        }
    }
}

extension PopupSelectBidVC : UITableViewDelegate, UITableViewDataSource {
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
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

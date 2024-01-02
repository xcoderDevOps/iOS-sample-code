//
//  PopupPlanDurationVC.swift
//  SOS
//
//  Created by Alpesh Desai on 01/01/21.
//

import UIKit

class PopupPlanDurationVC: MyPopupController {
    
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblPlan: UILabel!
    @IBOutlet weak var btnDuration: UIButton!
    @IBOutlet weak var viewPaymentOption: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var arrayData = [PlanDurationData]()
    
    var selectedDuration : PlanDurationData? {
        didSet {
            if let dur = selectedDuration {
                self.lblDuration.text = dur.Name
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let obj = self.objData as? PlanListData {
            lblPlan.text = obj.PlanCategory
            if obj.PlanCategory == "Free" {
                viewPaymentOption.isHidden = true
                btnDuration.isHidden = true
            } else {
                btnSubmit.isHidden = true
            }
        }

        callGetPlanDuration{ (data) in
            self.arrayData = data
            if let first = data.first {
                self.selectedDuration = first
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnDurationSelection(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: arrayData.compactMap({$0.Name})) { (str, index) in
            self.selectedDuration = self.arrayData[index]
        }
    }
    
    @IBAction func btnDismissPopup(_ sender: UIButton) {
        if pressCancel != nil {
            pressCancel!()
        }
    }
    
    @IBAction func btnSubmitCLK(_ sender: UIButton) {
        if let dur = selectedDuration {
            if pressOK != nil {
                pressOK!(dur.Id as AnyObject)
            }
        }
    }
    
    @IBAction func btnMakePayment(_ sender: UIButton) {
        if let dur = selectedDuration {
            if pressOK != nil {
                pressOK!(dur.Id as AnyObject)
            }
        }
    }
}

//
//  CreateSupportTicketVC.swift
//  GoldClean
//
//  Created by infolabh on 19/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class CreateSupportTicketVC: UIViewController {

    @IBOutlet weak var txtSupportTicket: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    
    var jobData = JobData()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Ticket"
        backButton(color: UIColor.white)
        
        lblSubTitle.isHidden = true

        // Do any additional setup after loading the view.
    }

    @IBAction func btnCreateTicketCLK(_ sender: UIButton) {
        if !txtSupportTicket.text!.isEmpty {
            var param = [String : Any]()
            if appDelegate.isFindService {
                param = [   "ShipperId": UserInfo.savedUser()!.Id,
                            "JobId": jobData.Id,
                            "Issue": txtSupportTicket.text!,
                            "JobNumber": jobData.JobNo,
                            "JobStatusId": jobData.JobStatusId ] as [String : Any]
            } else {
                param = [   "CarrierId": UserInfo.savedUser()!.Id,
                            "JobId": jobData.Id,
                            "Issue": txtSupportTicket.text!,
                            "JobNumber": jobData.JobNo,
                            "JobStatusId": jobData.JobStatusId ] as [String : Any]
            }
            wsAddTicketCLK(param: param) { (data) in
                if let data = data {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
    }
    
    @IBAction func btnTapTpSelectJob(_ sender: UIButton) {
        let controll = MainBoard.instantiateViewController(identifier: "CreatedJobListVC") as! CreatedJobListVC
        controll.completionBlock = { (data) -> Void in
            self.jobData = data
            self.lblTitle.text = data.JobNo
            self.lblSubTitle.text = "Date: \(data.PickupDate)"
            self.lblSubTitle.isHidden = false
        }
        self.present(controll, animated: true, completion: nil)
    }
    
    
}

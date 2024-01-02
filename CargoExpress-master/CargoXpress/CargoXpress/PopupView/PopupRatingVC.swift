//
//  PopupRatingVC.swift
//  CargoXpress
//
//  Created by infolabh on 21/07/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import FloatRatingView

class PopupRatingVC: MyPopupController {

    @IBOutlet weak var txtComment: LetsTextField!
    @IBOutlet weak var txtRating: FloatRatingView!
    
    var jobData = JobData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = objData as? JobData {
            jobData = data
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOkCLK(_ sender: UIButton) {
        let param = [   "JobId": jobData.Id,
                        "RatingToShipper": Int(txtRating.rating),
                        "CommentToShipper": txtComment.text!,
                        "UserType": appDelegate.isFindService ? "3" : "2"] as [String : Any]
        
        wsAddRatingCLK(param: param) { (data) in
            if let data = data {
                if self.pressOK != nil {
                   self.pressOK!(nil)
                }
            }
        }
        
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        if pressCancel != nil {
            pressCancel!()
        }
    }
}

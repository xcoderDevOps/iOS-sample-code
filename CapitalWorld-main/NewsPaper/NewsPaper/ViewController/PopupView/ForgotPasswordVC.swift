//
//  ForgotPasswordVC.swift
//  TraceableLive
//
//  Created by Alpesh Desai on 08/11/20.
//

import UIKit

class ForgotPasswordVC: MyPopupController {
    
    @IBOutlet weak var txtEmail: LetsFloatField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSubmitCLK(_ sender: UIButton) {
        guard let email = txtEmail.text, !email.isEmpty else {
            showAlert(popUpMessage.emptyEmailId.rawValue)
            return
        }
//        callForgotPasswordClk(email: txtEmail.text!) {
//            if self.pressOK != nil {
//                self.pressOK!(nil)
//            }
//        }
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        if pressCancel != nil {
            pressCancel!()
        }
    }

}

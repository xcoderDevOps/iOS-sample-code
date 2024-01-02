//
//  PopupOtpScreenVC.swift
//  iCognizance
//
//  Created by MickyBahu on 16/03/19.
//  Copyright © 2019 InfoLabh. All rights reserved.
//

import UIKit

struct MobileOtp {
    var mobile = ""
    var otp = ""
    var url = ""
}

class PopupOtpScreenVC: MyPopupController {

    @IBOutlet weak var viewPassCode: SimplePasscodeView!
    var passcode = ""
    var originalOTP = ""
    var mobileNum = ""
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPassCode.length = 4
        viewPassCode.delegate = self
        viewPassCode.keyboardType = .phonePad
        if let data = objData as? MobileOtp {
            originalOTP = data.otp
            mobileNum = data.mobile
            url = data.url
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        viewPassCode.becomeFirstResponder()
        if pressCancel != nil {
            pressCancel!()
        }
    }
  
    @IBAction func btnVerifyCLK(_ sender: UIButton) {
        viewPassCode.becomeFirstResponder()
        if originalOTP == passcode {
            if pressOK != nil {
                pressOK!(nil)
            }
        }
        else {
            showAlert("OTP was not valid. Please try again...")
        }
        
    }
    
    @IBAction func btnResendCodeCLK(_ sender: UIButton) {
        appDelegate.callGetOtpData(url: url) { (str) in
            if let str = str {
                self.originalOTP = str
                self.viewPassCode.becomeFirstResponder()
                showAlert("OTP send successfully")
                print(str)
            }
        }
    }
}

extension PopupOtpScreenVC : SimplePasscodeDelegate {
    func didDeleteBackward() {
        
    }
    
    func didFinishEntering(_ passcode: String) {
        self.passcode = passcode
        if passcode.ns.length == 4 {
            self.view.endEditing(true)
        }
    }
}

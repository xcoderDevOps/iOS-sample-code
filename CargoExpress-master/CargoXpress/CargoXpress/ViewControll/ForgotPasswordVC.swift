//
//  ForgotPasswordVC.swift
//  GoldClean
//
//  Created by infolabh on 18/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var stackMobile: UIView!
    @IBOutlet weak var stackOTP: UIView!
    @IBOutlet weak var stackPass: UIView!
    @IBOutlet weak var btnReset: UIButton!
    
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var txtPasss: UITextField!
    @IBOutlet weak var txtConPasss: UITextField!
    
    var countryData = [CountryData]()
    var selectedCountry : CountryData?
    
    enum ResetState : Int {
        case sentOTP = 0
        case submitOtp = 1
        case resetPass = 2
    }
    
    var state = ResetState(rawValue: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideAllStack()
        stackMobile.isHidden = false
        lblMessage.text = "Please enter your registered mobile number. OTP will be sent via sms."
        // Do any additional setup after loading the view.
    }
    
    func hideAllStack() {
        stackMobile.isHidden = true
        stackOTP.isHidden = true
        stackPass.isHidden = true
    }
    
    @IBAction func btnOpenCountry(_ sender: UIButton) {
        openCountryDropDown(anchorView: sender, data: countryData) { (str, index) in
            self.txtCountry.text = str
            self.selectedCountry = self.countryData[index]
        }
    }
    var info = UserInfo()
    var mobileOtp = ""
    @IBAction func btnResetPassAction(_ sender: UIButton) {
        switch state {
            case .sentOTP:
                //Call API For Sent OTP
                guard let con = selectedCountry else {
                    showAlert("Please select country")
                    return
                }
                if txtMobileNo.text!.isEmpty {
                    showAlert("Please enter your mobile number")
                    return
                }
                let param = [   "CountryId": con.Id,
                                "PhoneNumber":txtMobileNo.text!,
                                "LoginType":false] as [String : Any]
                var url = ""
                
                if appDelegate.isFindService {
                    url = baseURL + URLS.ShipperLogin.rawValue
                } else {
                    url = baseURL + URLS.Carriers_Login.rawValue
                }
                
                callLoginSignUp(url: url, param) { (info) in
                    if let info = info  {
                        self.info = info
                        let otpUrl = baseURL + URLS.adminOtp.rawValue + con.CountryCode + info.PhoneNumber
                        
                        appDelegate.callGetOtpData(url: otpUrl) { (str) in
                            if let str = str {
                                print("OTP is: \(str)")
                                self.mobileOtp = str
                                self.btnReset.setTitle("Verify", for: UIControl.State.normal)
                                self.hideAllStack()
                                self.stackOTP.isHidden = false
                                self.state = ResetState.submitOtp
                                self.lblMessage.text = "OTP send successfully to your registered mobile number."
                            }
                        }
                        
                        
                    }
            }
            case .submitOtp :
                if self.mobileOtp == txtOTP.text! {
                    lblMessage.text = "Reset your password."
                    btnReset.setTitle("Submit", for: UIControl.State.normal)
                    self.hideAllStack()
                    stackPass.isHidden = false
                    state = ResetState.resetPass

                } else {
                    showAlert("Please Enter Valide OTP")
                }
            break
            case .resetPass:
                
                let param = ["Id":self.info.Id,
                             "Type":1,
                             "OldPassword":self.info.Password,
                             "NewPassword":txtPasss.text!,
                             "ConfirmPassword":txtConPasss.text!] as [String : Any]
                var url = ""
                if appDelegate.isFindService {
                    url = baseURL + URLS.Shippers_ChangePassword.rawValue
                } else {
                    url = baseURL + URLS.Carriers_ChangePassword.rawValue
                }
                callLoginSignUp(url: url, param) { (info) in
                    if let info = info {
                        info.isFindService = appDelegate.isFindService
                        info.save()
                        showAlert("Password Changed Successfully")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            case .none:
                break
        }
        
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnDismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  LoginVC.swift
//  TraceableLive
//
//  Created by Alpesh Desai on 02/11/20.
//

import UIKit
import SROTPView
import FirebaseMessaging

class LoginVC: UIViewController {

    @IBOutlet weak var txtPhone: LetsFloatField!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var viewOtp: SROTPView!
    
    @IBOutlet weak var viewResend: UIView!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var lblOtp: UILabel!
    
    @IBOutlet weak var viewLogout: UIView!
    @IBOutlet weak var  lblLogout: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewResend.isHidden = true
        viewBg.isHidden = true
        viewLogout.isHidden = true
        setupOtpView()
    }
    
    var userInfo : UserInfo?
    var enteringOtp = ""
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtPhone.becomeFirstResponder()
    }
    
    func setupOtpView() {
        viewOtp.otpTextFieldsCount = 4
        viewOtp.otpTextFieldActiveBorderColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
        viewOtp.otpTextFieldDefaultBorderColor = UIColor.black
        viewOtp.otpTextFieldFontColor = UIColor.black
//        viewOtp.activeHeight = 4
//        viewOtp.inactiveHeight = 2
        viewOtp.otpType = .Bordered //.Rounded for round
        viewOtp.otpEnteredString = { pin in
            print("The entered pin is \(pin)")
            self.enteringOtp = "\(pin)"
        }
        viewOtp.setUpOtpView()
    }
    
    @IBAction func btnResendOtpCLK(_ sender: LetsButton) {
        self.userInfo = nil
        btnSignInCLK(LetsButton())
    }
    
    @IBAction func btnlogoutAllCLK(_ sender: LetsButton) {
        let url = baseURL + URLS.Users_Force_Logout.rawValue + "\(txtPhone.text!)"
        callGetUserData(url, param: [:]) { (data, code, msg) in
            showAlert(msg)
            self.viewLogout.isHidden = true
            self.btnSignInCLK(LetsButton())
        }
    }
    
    @IBAction func btnSignInCLK(_ sender: LetsButton) {
        self.view.endEditing(true)
        if let info = userInfo {
            if enteringOtp == info.OTP {
                info.save()
                appDelegate.gotToDashBoardView()
            } else {
                showAlert(popUpMessage.ValidPasscode.rawValue)
            }
        } else {
            if !checkInternet() {
                showAlert(popUpMessage.NoInternet.rawValue)
                return
            }
            
            if validePhoneNumber(txtPhone.text!) {
                showAlert(popUpMessage.PhoneValid.rawValue)
                return
            }
            
            guard let firebaseToken = Messaging.messaging().fcmToken  else { return}
            
            let param = ["PhoneNumber":txtPhone.text!,
                         "DeviceToken":firebaseToken,
                         "DeviceUDId":UIDevice.current.identifierForVendor!.uuidString,
                         "OS":"iOS"]
           
            callGetUserData(baseURL+URLS.LoginUsers.rawValue, param: param) { (data, code, msg) in
                if let data = data {
                    print(data)
                    self.viewResend.isHidden = false
                    self.viewBg.isHidden = false
                    self.viewOtp.initializeUI()
                    self.userInfo = data
                    //showAlert(data.OTP)
                    print(data.OTP)
                    UIView.animate(withDuration: 0.33) {
                        self.view.layoutIfNeeded()
                    }
                } else if code == 400 {
                    self.lblLogout.text = "This account with this number \(self.txtPhone.text!) is already login with another device. Please tap on logout to use this device."
                    self.viewLogout.isHidden = false
                    
                }
            }
        }
    }
}

//
//  LoginVC.swift
//  SOS
//
//  Created by Alpesh Desai on 27/12/20.
//

import UIKit
import FirebaseMessaging
import AppTrackingTransparency

class LoginVC: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var viewCode: UIView!
    @IBOutlet weak var lblTopTitle: UILabel!
    @IBOutlet weak var txtCode: LetsTextField!
    @IBOutlet weak var txtUserNameMobile: LetsTextField!
    @IBOutlet weak var txtPassword: LetsTextField!
    
    var countryData : CountryData? {
        didSet {
            if let code = countryData {
                self.txtCode.text = code.CountryCode
            }
        }
    }
    var arrayCountry = [CountryData]() {
        didSet {
            if let data = arrayCountry.first {
                countryData = data
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        callGetCountryList { (data) in
            self.arrayCountry = data
        }
//        txtUserNameMobile.text = "test_76"
//        txtPassword.text = "123Password@"
        // Do any additional setup after loading the view.
    }

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        self.txtUserNameMobile.text = ""
        if sender.selectedSegmentIndex == 0 {
            viewCode.isHidden = true
            lblTopTitle.text = "UserName"
            txtUserNameMobile.placeholder = "Enter Username"
            txtUserNameMobile.keyboardType = .asciiCapable
        } else {
            viewCode.isHidden = false
            if let code = countryData {
                txtCode.text = code.CountryCode
            } else {
                txtCode.text = ""
            }
            lblTopTitle.text = "Mobile Number"
            txtUserNameMobile.placeholder = "Enter Mobile Number"
            txtUserNameMobile.keyboardType = .phonePad
        }
    }
    
    @IBAction func btnEyeClk(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        txtPassword.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func btnLoginClk(_ sender: UIButton) {
        var url = baseURL+URLS.LogIn.rawValue
        url.append("?password=\(txtPassword.text!)")
        if segment.selectedSegmentIndex == 0 {
            url.append("&UserName=\(txtUserNameMobile.text!)")
        } else {
            guard let code = countryData else {
                return
            }
            url.append("&UserName=\(txtUserNameMobile.text!)&CountryId=\(code.Id)")
        }
        guard let firebaseToken = Messaging.messaging().fcmToken  else { return}
        url.append("&DeviceToken=\(firebaseToken)&DeviceInfo=iOS")
        print(url)
        callLoginWithUrl(url) { (info, flag) in
            if let info = info {
                info.save()
                if flag {
                    appDelegate.gotToDashBoardView()
                } else {
                    appDelegate.gotToDashBoardView()
//                    if info.UserType == 1 {
//                        UserDefaults.standard.setValue(true, forKey: "PlanRemain")
//                        appDelegate.gotToPlanSelection()
//                    } else {
//                        appDelegate.gotToDashBoardView()
//                    }
                }
            }
            
        }
    }
    
    @IBAction func btnSignupClk(_ sender: UIButton) {
        self.openSignUp()
        /*
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                print(status)
                if status == .authorized {
                    self.openSignUp()
                } else {
                    self.alertShow(self, title: "Allow this app to track you across the app.", message: "In iPhone settings, tap on SOS app and Allow Tracking", okStr: "Open Settings", cancelStr: "Not Now") {
                        if let url = URL(string:UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(url)
                        }
                    } cancelClick: {}
                }
            })
        } else {
            self.openSignUp()
        }
         */
    }
    
    func openSignUp() {
        let controll = LoginBord.instantiateViewController(identifier: "SignupNav")
        controll.modalPresentationStyle = .fullScreen
        self.present(controll, animated: true, completion: nil);
    }
    
    @IBAction func btnForgotClk(_ sender: UIButton) {
        let controll = LoginBord.instantiateViewController(identifier: "ForgotPasswrodVC") as! ForgotPasswrodVC
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    @IBAction func btnCodeClk(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: arrayCountry.compactMap({"\($0.CountryCode) (\($0.Name))"})) { (str, index) in
            self.countryData = self.arrayCountry[index]
        }
    }
}

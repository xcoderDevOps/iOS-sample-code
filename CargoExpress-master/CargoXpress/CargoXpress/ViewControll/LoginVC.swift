//
//  LoginVC.swift
//  AddressBoook
//
//  Created by Bindle Ilc. on 18/07/16.
//  Copyright © 2016 Bindle Ilc.. All rights reserved.
//

import UIKit
import SVProgressHUD
import DropDown
import FirebaseMessaging

class LoginVC: UIViewController , UITextFieldDelegate, UIScrollViewDelegate{
   
    //MARK: - Variable declaration -
    
    @IBOutlet weak var txtSignInPhoneNo: LetsTextField!
    @IBOutlet weak var txtSignInPassword: LetsTextField!
    @IBOutlet weak var txtSignInCountry: LetsTextField!
    
    
    @IBOutlet weak var constrainX: NSLayoutConstraint!
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    
    @IBOutlet weak var btnSignIN: UIButton!
    @IBOutlet weak var btnSignUP: UIButton!
    
    @IBOutlet weak var txtCountryCode: LetsTextField!
    @IBOutlet weak var txtFirstName: LetsTextField!
    @IBOutlet weak var txtLastName: LetsTextField!
    @IBOutlet weak var txtEmail: LetsTextField!
    @IBOutlet weak var txtSignUpPass: LetsTextField!
    @IBOutlet weak var txtPhoneNo: LetsTextField!
    @IBOutlet weak var txtConfirmPass: LetsTextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    var countryData = [CountryData]()
    var selectedCountry : CountryData?
    
   //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign in"
        
        if appDelegate.isFindService {
            lblTitle.text = "Find Service"
        } else {
            lblTitle.text = "Become Carrier"
        }
        
        self.callGetCountryList { (data) in
            self.countryData = data
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        btnSignIN.isSelected = true
        btnSignUP.isSelected = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        constrainX.constant = btnSignIN.frame.size.width / 2
    }
    
    // MARK:KEYBOARD NOTIFICATION EVENTS
    @objc func keyboardWillShow(_ notification: Notification) {
        var frm = self.view.frame
        let userInfo = notification.userInfo
        frm.origin.y = -(topView.frame.size.height) + appDelegate.window!.safeAreaInsets.top + 64
        let duration:TimeInterval = (userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        UIView.animate(withDuration: duration, animations: { [unowned self]() -> Void in
            self.view.frame = frm
        })
        
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        var frm = self.view.frame
        frm.origin.y = 0
        let userInfo = notification.userInfo
        let duration:TimeInterval = (userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.frame = frm
        })
    }
    
    @IBAction func btnSignInCountryCode(_ sender: UIButton) {
        openCountryDropDown(anchorView: sender, data: countryData) { (str, index) in
            self.txtSignInCountry.text = str
            self.selectedCountry = self.countryData[index]
        }
    }
    
    @IBAction func btnSignUpCountryCode(_ sender: UIButton) {
        openCountryDropDown(anchorView: sender, data: countryData) { (str, index) in
            self.txtCountryCode.text = str
            self.selectedCountry = self.countryData[index]
        }
    }
    
    @IBAction func btnTermsAndClonditionClicked(_ sender: UIButton) {
        //https://www.termsfeed.com/live/fd07f3b6-81f7-46b8-8754-d4ad4acc1557
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func btnViewSignInClicked(_ sender: UIButton) {
        clearSelection()
        sender.isSelected = true
        self.view.endEditing(true)
        mainScrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    @IBAction func btnViewSignUpClicked(_ sender: UIButton) {
        clearSelection()
        sender.isSelected = true
        self.view.endEditing(true)
        mainScrollView?.setContentOffset(CGPoint(x: self.view.frame.size.width, y: 0), animated:true)
    }
    
    @IBAction func btnSignInClicked(_ sender: UIButton)
    {
        self.view.endEditing(true)
        if validationSignIn()
        {
            guard let selectedCountry = selectedCountry else {
                showAlert("Please select country")
                return
            }
            
            guard let firebaseToken = Messaging.messaging().fcmToken  else { return}
            let num = txtSignInPhoneNo.text!.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
            
            let param = [     "CountryId" : selectedCountry.Id,
                              "PhoneNumber" : num,
                              "Password" : txtSignInPassword.text!,
                              "DeviceToken": firebaseToken,
                              "LoginType":true] as [String : Any]
            var url = ""
            
            if appDelegate.isFindService {
                url = baseURL + URLS.ShipperLogin.rawValue
            } else {
                url = baseURL + URLS.Carriers_Login.rawValue
            }
            
            callLoginSignUp(url: url, param) { (info) in
                if let info = info {
                    print(info)
                    info.isFindService = appDelegate.isFindService
                    info.save()
                    appDelegate.gotToDashBoardView()
                }
            }
        }
    }

    
    
    @IBAction func btnSignUPClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if validationSignUp()
        {
            guard let selectedCountry = selectedCountry else {
                showAlert("Please select country")
                return
            }
            guard let firebaseToken = Messaging.messaging().fcmToken  else { return}
            let num = txtPhoneNo.text!.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
            let param = [ "CountryId" : selectedCountry.Id,
                              "FirstName" : txtFirstName.text!,
                              "LastName" : txtLastName.text!,
                              "PhoneNumber" : num,
                              "Password" : txtSignUpPass.text!,
                              "ConfirmPassword" : txtSignUpPass.text!,
                              "Email": txtEmail.text!,
                              "DeviceToken": firebaseToken,
                              "LoginType":true] as [String : Any]
            //Call Signup API
            var url = ""
            
            if appDelegate.isFindService {
                url = baseURL + URLS.ShipperSignup.rawValue
            } else {
                url = baseURL + URLS.CarrierSignup.rawValue
            }
            
            callLoginSignUp(url: url, param) { (info) in
                if let info = info {
                    
                    let otpUrl = baseURL + URLS.adminOtp.rawValue + selectedCountry.CountryCode + num
                    print(otpUrl)
                    appDelegate.callGetOtpData(url: otpUrl) { (str) in
                        let mobileOtp = MobileOtp(mobile: info.PhoneNumber, otp: str!, url: otpUrl)
                        showAlert("OTP send to your registed mobile. Please verify to login")
                        print(str!)
                        _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupOtpScreenVC", blockOK: { (data) in
                            dismissPopUp()
                            info.isFindService = appDelegate.isFindService
                            info.save()
                            appDelegate.gotToDashBoardView()
                        }, blockCancel: {
                            dismissPopUp()
                        }, objData: mobileOtp as AnyObject)
                    }
                }
            }
        }
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: UIButton) {
        let controll = LoginBord.instantiateViewController(identifier: "ForgotPasswordVC") as! ForgotPasswordVC
        controll.countryData = self.countryData
        self.present(controll, animated: true, completion: nil)
    }
    
    func clearSelection()
    {
        btnSignIN.isSelected = false
        btnSignUP.isSelected = false
    }
    
    // MARK:SCROLL VIEW DELEGATE
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        constrainX.constant = scrollView.contentOffset.x/4 + btnSignUP.frame.size.width/2
        
        UIView.animate(withDuration: 0.22, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth : CGFloat! = scrollView.frame.size.width // you need to have a **iVar** with getter for scrollView
        let fractionalPage : CGFloat! = scrollView.contentOffset.x / pageWidth
        let page : NSInteger! = lroundf(Float(fractionalPage!))
        
        clearSelection()
        
        if (page == 0)
        {
            btnSignIN.isSelected = true
        }
        else
        {
            btnSignUP.isSelected = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validationSignIn() -> Bool
    {
        if  isEmptyString(txtSignInPhoneNo.text!) || isEmptyString(txtSignInPassword.text!) || selectedCountry == nil {
            showAlert(popUpMessage.emptyString.rawValue)
            return false
        }
        else{
            return true
        }
    }
    
    
    func validationSignUp() -> Bool
    {
        if  isEmptyString(txtFirstName.text!) || isEmptyString(txtLastName.text!) || isEmptyString(txtPhoneNo.text!) || isEmptyString(txtSignUpPass.text!) || isEmptyString(txtConfirmPass.text!) || isEmptyString(txtEmail.text!) || selectedCountry == nil {
            showAlert(popUpMessage.emptyString.rawValue)
            return false
        }
        else if txtSignUpPass.text!.ns.length < 6 || txtSignUpPass.text!.ns.length > 16
        {
            showAlert(popUpMessage.PasswordValid.rawValue)
            return false
        }
        else if txtConfirmPass.text != txtSignUpPass.text {
            showAlert(popUpMessage.ConPassword.rawValue)
            return false
        }
        else{
            return true
        }
    }
    
    //MARK: Textfield Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if txtSignInPhoneNo == textField || txtPhoneNo == textField {
            var fullString = textField.text ?? ""
            fullString.append(string)
            if range.length == 1 {
                textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
            } else {
                textField.text = format(phoneNumber: fullString)
            }
            return false
        }
        if textField.textInputMode?.primaryLanguage == nil {
            return false
        }
        
        return true
    }
}


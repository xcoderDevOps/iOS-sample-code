//
//  CarrierShipperSignupVC.swift
//  CargoXpress
//
//  Created by infolabh on 26/09/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

var carrierSideShipperId : Int?

class CarrierShipperSignupVC: UIViewController {

    @IBOutlet weak var txtCountryCode: LetsTextField!
    @IBOutlet weak var txtFirstName: LetsTextField!
    @IBOutlet weak var txtLastName: LetsTextField!
    @IBOutlet weak var txtEmail: LetsTextField!
    @IBOutlet weak var txtSignUpPass: LetsTextField!
    @IBOutlet weak var txtPhoneNo: LetsTextField!
    @IBOutlet weak var txtConfirmPass: LetsTextField!
    
    var countryData = [CountryData]()
    var selectedCountry : CountryData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carrierSideShipperId = nil
        backButton(color: UIColor.white)
        self.callGetCountryList { (data) in
            self.countryData = data
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btnSignUpCountryCode(_ sender: UIButton) {
        openCountryDropDown(anchorView: sender, data: countryData) { (str, index) in
            self.txtCountryCode.text = str
            self.selectedCountry = self.countryData[index]
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
            
            let num = txtPhoneNo.text!.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
            let param = [ "CountryId" : selectedCountry.Id,
                              "FirstName" : txtFirstName.text!,
                              "LastName" : txtLastName.text!,
                              "PhoneNumber" : num,
                              "Password" : txtSignUpPass.text!,
                              "ConfirmPassword" : txtSignUpPass.text!,
                              "Email": txtEmail.text!,
                              "DeviceToken": getDeviceToken(),
                              "LoginType":true] as [String : Any]
            //Call Signup API
            let url = baseURL + URLS.ShipperSignup.rawValue
            callLoginSignUp(url: url, param) { (info) in
                if let info = info {
                    let otpUrl = baseURL + URLS.adminOtp.rawValue + selectedCountry.CountryCode + info.PhoneNumber
                    appDelegate.callGetOtpData(url: otpUrl) { (str) in
                        let mobileOtp = MobileOtp(mobile: info.PhoneNumber, otp: str!, url: otpUrl)
                        showAlert("OTP send to your registed mobile. Please verify to login")
                        print(str!)
                        _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupOtpScreenVC", blockOK: { (data) in
                            dismissPopUp()
                            carrierSideShipperId = info.Id
                            let controll = MainBoard.instantiateViewController(identifier: "DashboardVC") as! DashboardVC
                            self.navigationController?.pushViewController(controll, animated: true)
                        }, blockCancel: {
                            dismissPopUp()
                        }, objData: mobileOtp as AnyObject)
                    }
                }
            }
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

}

//
//  CarrierShipperLoginVC.swift
//  CargoXpress
//
//  Created by Alpesh Desai on 15/11/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class CarrierShipperLoginVC: UIViewController {

    @IBOutlet weak var txtCountryCode: LetsTextField!
    @IBOutlet weak var txtMobileNum: LetsTextField!
    
    var countryData = [CountryData]()
    var selectedCountry : CountryData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftDriverMenuButton()
        carrierSideShipperId = nil
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

    @IBAction func btnSignInClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if validationSignUp()
        {
            guard let selectedCountry = selectedCountry else {
                showAlert("Please select country")
                return
            }
            
            let num = txtMobileNum.text!.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
            
            //Call Signup API
            
            let url = baseURL + URLS.ShipperVerifyMobileNo.rawValue + "?CarrierId=\(UserInfo.savedUser()!.Id)&ShipperMobileNo=\(num)&CountryId=\(selectedCountry.Id)&CountryCode=\(selectedCountry.CountryCode)"
            print(url)
            
            callLoginSignUp(url: url, [String:Any]()) { (info) in
                if let info = info {
                    let otpUrl = baseURL + URLS.adminOtp.rawValue + selectedCountry.CountryCode + info.PhoneNumber
                    let mobileOtp = MobileOtp(mobile: info.PhoneNumber, otp: info.Otp, url: otpUrl)
                    showAlert("OTP send to shipper's mobile. Please verify to login")
                    print(info.Otp)
                    _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupOtpScreenVC", blockOK: { (data) in
                        dismissPopUp()
                        carrierSideShipperId = info.Id
                        let controll = MainBoard.instantiateViewController(identifier: "DashboardVC") as! DashboardVC
                        self.navigationController?.pushViewController(controll, animated: true)
                    }, blockCancel: {
                        dismissPopUp()
                    }, objData:mobileOtp  as AnyObject)
                } else {
                    showAlert("This number not registered with the shipper account. Please signup as shipper")
                }
            }
        }
    }
    
    @IBAction func btnSignUPClicked(_ sender: UIButton) {
        let controll = DriverBoard.instantiateViewController(identifier: "CarrierShipperSignupVC") as! CarrierShipperSignupVC
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    func validationSignUp() -> Bool
    {
        if  isEmptyString(txtMobileNum.text!) || selectedCountry == nil {
            showAlert(popUpMessage.emptyString.rawValue)
            return false
        }
        else{
            return true
        }
    }
    
}

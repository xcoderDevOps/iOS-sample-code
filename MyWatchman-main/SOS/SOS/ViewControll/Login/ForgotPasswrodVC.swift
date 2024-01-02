//
//  ForgotPasswrodVC.swift
//  SOS
//
//  Created by Alpesh Desai on 27/12/20.
//

import UIKit

class ForgotPasswrodVC: UIViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var lblTitleDesc: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var viewCode: UIView!
    @IBOutlet weak var txtCode: LetsTextField!
    @IBOutlet weak var txtEmailMobile: LetsTextField!
    
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
        lblTitleDesc.text = "Please enter the e-mail associated with your account to receive a password reset link."
        callGetCountryList { (data) in
            self.arrayCountry = data
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCodeClk(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: arrayCountry.compactMap({"\($0.CountryCode) (\($0.Name))"})) { (str, index) in
            self.countryData = self.arrayCountry[index]
        }
    }

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        txtEmailMobile.text = ""
        if sender.selectedSegmentIndex == 0 {
            viewCode.isHidden = true
            lblSubTitle.text = "Email Id"
            txtEmailMobile.placeholder = "Enter Email Id"
            txtEmailMobile.keyboardType = .emailAddress
            lblTitleDesc.text = "Please enter the e-mail associated with your account to receive a password reset link."
        } else {
            viewCode.isHidden = false
            txtCode.text = ""
            lblSubTitle.text = "Mobile Number"
            txtEmailMobile.placeholder = "Enter Mobile Number"
            txtEmailMobile.keyboardType = .phonePad
            lblTitleDesc.text = "Please enter the mobile number associated with your account to receive an OTP to reset password."
        }
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func btnTapToVerifyCLK(_ sender: UIButton) {
        if segment.selectedSegmentIndex == 0 {
            let urlStr = baseURL+URLS.ForgotPassword.rawValue+"\(txtEmailMobile.text!)"
            self.callPostForgot(url: urlStr) { (info) in
                if info != nil {
                    showAlert("Email Verified Successfully. Reset password link has been sent to your email please check your mail.")
                }
            }
        } else {
            guard let con = countryData else {
                return
            }
            guard let enc = "\(txtEmailMobile.text!)&CountryId=\(con.Id)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {return}
            let url = baseURL + URLS.CustomerOtpMobileExists.rawValue + enc
            print(url)
            callGetUserData(url) { (info) in
                if let info = info {
                    let controll = LoginBord.instantiateViewController(identifier: "OTPVerificationVC") as! OTPVerificationVC
                    controll.info = info
                    controll.isRegister = false
                    controll.mobileNo = "\(self.txtCode.text!)\(self.txtEmailMobile.text!)"
                    self.navigationController?.pushViewController(controll, animated: true)
                }
            }
        }
    }
}

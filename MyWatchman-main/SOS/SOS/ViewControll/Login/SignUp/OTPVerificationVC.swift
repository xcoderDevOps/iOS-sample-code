//
//  OTPVerificationVC.swift
//  TradeBin
//
//  Created by infolabh on 18/08/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import OTPTextField

class OTPVerificationVC: UIViewController, OTPTextFieldDelegate {
    
    @IBOutlet weak var txtOtp: OTPTextField!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var lblSecond: UILabel!
    
    @IBOutlet weak var stackCounter: UIStackView!
    @IBOutlet weak var stackResendBtn: UIStackView!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnCnacel: UIButton!
    @IBOutlet weak var createAcc: UILabel!
    
    var param = [String : Any]()
    var info : UserInfo?
    var mobileNo = ""
    var isRegister = true
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        txtOtp.otpDelegate = self
        stackResendBtn.isHidden = true
        txtOtp.textContentType = .oneTimeCode
        txtOtp.becomeFirstResponder()
        self.lblMobileNo.text = mobileNo
       
        btnBack.isHidden = !isRegister
        btnCnacel.isHidden = !isRegister
        createAcc.isHidden = !isRegister
        // Do any additional setup after loading the view.
    }
    var count = 30
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        runTimer()
        print(info)
    }
    
    func runTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.count = self.count - 1
            if self.count == 0 {
                timer.invalidate()
                DispatchQueue.main.async {
                    self.stackResendBtn.isHidden = false
                    self.stackCounter.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.lblSecond.text = "\(self.count)"
                }
            }
        }).fire()
    }
    
    @IBAction func btnContinueCLK(_ sender: UIButton) {
        if let info = info, txtOtp.text!.count == 4 && info.Otp == txtOtp.text! {
            if isRegister {
                let controll = LoginBord.instantiateViewController(identifier: "EnterPasswordVC") as! EnterPasswordVC
                self.navigationController?.pushViewController(controll, animated: true)
                
            } else {
                let controll = LoginBord.instantiateViewController(identifier: "ResetPasswordVC") as! ResetPasswordVC
                controll.info = info
                self.navigationController?.pushViewController(controll, animated: true)
            }
        }
    }
    
    @IBAction func btnResendOTPCLK(_ sender: UIButton) {
        var url = ""
        guard let enc = "\(mobileNo)".addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {return}
        if let info = info, !info.Otp.isEmpty {
            url = baseURL + URLS.ResendOtp.rawValue + enc + "&Otp=\(info.Otp)"
        } else {
            url = baseURL + URLS.CustomerOtpMobileExists.rawValue + enc
        }
        print(url)
        callGetUserData(url) { (inf) in
            if let inf = inf {
                self.info = inf
                print(inf.Otp)
                self.stackCounter.isHidden = false
                self.stackResendBtn.isHidden = true
                self.count = 30
                //showAlert(info.Otp)
                DispatchQueue.main.async {
                    self.runTimer()
                }
            }
        }
        
    }
    
    func otpTextField(_ textField: OTPTextField, didChange otpCode: String) {
        if otpCode.count == 4 {
            btnContinue.backgroundColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1)
        } else {
            btnContinue.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        }
    }
    
    @IBAction func btnBackCLK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        registerData = RegisterData()
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  EnterUserNamePhoneVC.swift
//  SOS
//
//  Created by Alpesh Desai on 04/03/21.
//

import UIKit

class EnterUserNamePhoneVC: UIViewController {

    @IBOutlet weak var txtUser: LetsTextField!
    @IBOutlet weak var txtCode: LetsTextField!
    @IBOutlet weak var txtMobile: LetsTextField!
    
    var countryData : CountryData? {
        didSet {
            if let code = countryData {
                registerData.country = code
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
        txtUser.delegate = self
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
    
    @IBAction func btnDismissCLK(_ sender: UIButton) {
        registerData = RegisterData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBackCLK(_ sender: UIButton) {
        registerData.phoneNum = txtMobile.text!
        registerData.username = txtUser.text!
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueCLK(_ sender: UIButton) {
        if  isEmptyString(txtUser.text!) || isEmptyString(txtMobile.text!) || countryData == nil
        {
            showAlert(popUpMessage.emptyString.rawValue)
            return
        }
        registerData.phoneNum = "\(txtMobile.text!)"
        registerData.username = txtUser.text!
        guard let con = countryData else {
            return
        }
        guard let enc1 = "\(registerData.phoneNum)&CountryId=\(con.Id)".addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {return}
        
        guard let enc2 = "\(registerData.username)".addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {return}
        
        let url = baseURL + URLS.CustomerGenerateOTP.rawValue + enc1 + "&Username=\(enc2)"
        print(url)
        callGetUserData(url) { (info) in
            if let info = info {
                self.callSignUp(info: info)
            }
        }
        
    }
    
    func callSignUp(info:UserInfo) {
        let controll = LoginBord.instantiateViewController(identifier: "OTPVerificationVC") as! OTPVerificationVC
        controll.info = info
        controll.mobileNo = "\(txtCode.text!)\(txtMobile.text!)"
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension EnterUserNamePhoneVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtUser {
            if string == " " {
                return false
            }
        }
        return true
    }
}

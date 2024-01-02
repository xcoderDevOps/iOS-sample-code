//
//  ChangePasswordVC.swift
//  ECigar
//
//  Created by Alpesh Desai on 26/11/20.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var txtCurrentPass: LetsTextField!
    @IBOutlet weak var txtNewPass: LetsTextField!
    @IBOutlet weak var txtConfPass: LetsTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapOnChangePassword(_ sender:UIButton) {
        guard let info = UserInfo.savedUser() else { return }
        if validationSignUp() {
            let param = ["Id": info.Id,
                         "OldPassword": txtCurrentPass.text!,
                         "NewPassword":txtNewPass.text!,
                         "ConfirmPassword":txtConfPass.text!] as [String : Any]
            callChangePass(baseURL+URLS.Users_ChangePassword.rawValue, param: param) { data in
                
            }
        }
    }
    
    func validationSignUp() -> Bool
    {
        if isEmptyString(txtCurrentPass.text!) || isEmptyString(txtNewPass.text!) || isEmptyString(txtNewPass.text!) {
            showAlert(popUpMessage.emptyString.rawValue)
            return false
        }
        else if txtConfPass.text != txtNewPass.text {
            showAlert(popUpMessage.ConPassword.rawValue)
            return false
        } else{
            return true
        }
    }
    
}

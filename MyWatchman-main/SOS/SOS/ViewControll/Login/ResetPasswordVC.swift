//
//  ResetPasswordVC.swift
//  SOS
//
//  Created by Alpesh Desai on 28/12/20.
//

import UIKit

class ResetPasswordVC: UIViewController {

    @IBOutlet weak var txtNewPass: LetsTextField!
    @IBOutlet weak var txtConfPass: LetsTextField!
    
    var info : UserInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        title = "Reset Password"
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnSavePasswordCLK(_ sender: UIButton) {
        if txtNewPass.text!.isEmpty || txtConfPass.text!.isEmpty {
            showAlert(popUpMessage.emptyString.rawValue)
            return
        } else if txtNewPass.text != txtConfPass.text! {
            showAlert(popUpMessage.ConPassword.rawValue)
            return
        }
        guard  let info = info else {
            return
        }
        let url = baseURL + URLS.ChangePassword.rawValue
        callPostUserDataAPI(url: url, param: ["Id":info.CustomerId, "Password":txtNewPass.text!]) { (info) in
            if let info = info {
                showAlert("Password reset successfully")
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

//
//  ChangePasswordVC.swift
//  UIDevelopment
//
//  Created by MickyBahu on 26/05/19.
//  Copyright © 2019 InfoLabh. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet weak var txtCurrent: LetsFloatField!
    @IBOutlet weak var txtNew: LetsFloatField!
    @IBOutlet weak var txtConNew: LetsFloatField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Change Password"
        backButton(color: UIColor.white)
        
        txtCurrent.delegate = self
        txtNew.delegate = self
        txtConNew.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSubmitCLK(_ sender: LetsButton) {
        if validation() {
            var url = ""
            if UserInfo.savedUser()!.isFindService {
                url = baseURL + URLS.Shippers_ChangePassword.rawValue
            } else {
                url = baseURL + URLS.Carriers_ChangePassword.rawValue
            }
            let param = [     "Id":UserInfo.savedUser()!.Id,
                              "OldPassword" : txtCurrent.text!,
                              "NewPassword" : txtNew.text!,
                              "ConfirmPassword" : txtNew.text!,
                              "Type":1] as [String : Any]
            //Call Signup API
            
            callLoginSignUp(url: url, param) { (info) in
                if let info = info {
                    info.isFindService = appDelegate.isFindService
                    info.save()
                    showAlert("Password changed successfully")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }


    
    func validation()-> Bool {
        if isEmptyString(txtCurrent.text!) {
            showAlert(popUpMessage.EmptyCurrentPass.rawValue)
            return false
        }
        else if txtCurrent.text! != UserInfo.savedUser()!.Password {
            showAlert(popUpMessage.currentPass.rawValue)
            return false
        }
        else if isEmptyString(txtNew.text!) {
            showAlert(popUpMessage.EmptyNewPass.rawValue)
            return false
        }
        else if validePasswordWithLenght(txtNew.text!) {
            showAlert(popUpMessage.PasswordValid.rawValue)
            return false
        }
//        else if validatePasswordWithString(txtNew.text!) {
//            showAlert(popUpMessage.PasswrordValid.rawValue)
//            return false
//        }
        else if isEmptyString(txtConNew.text!) {
            showAlert(popUpMessage.EmptyConfirmPass.rawValue)
            return false
        }
        else if txtConNew.text! != txtNew.text! {
            showAlert(popUpMessage.ConPassword.rawValue)
            return false
        }
        else {
            return true
        }
    }
}

extension ChangePasswordVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtCurrent == textField || txtNew == textField || txtConNew == textField{
            let maxLength = 16
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else {
            return true
        }
    }
}


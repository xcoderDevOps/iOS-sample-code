//
//  PopupAddDriverVC.swift
//  CargoXpress
//
//  Created by infolabh on 09/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class PopupAddDriverVC: MyPopupController {

    @IBOutlet weak var txtCountryCode: LetsTextField!
    @IBOutlet weak var txtFirstName: LetsTextField!
    @IBOutlet weak var txtLastName: LetsTextField!
    @IBOutlet weak var txtEmailId: LetsTextField!
    @IBOutlet weak var txtMobileNo: LetsTextField!
    @IBOutlet weak var txtPassword: LetsTextField!
    
    var countryData = [CountryData]()
    var selectedCountry : CountryData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.callGetCountryList { (data) in
            self.countryData = data
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCountryCode(_ sender: UIButton) {
        openCountryDropDown(anchorView: sender, data: countryData) { (str, index) in
            self.txtCountryCode.text = str
            self.selectedCountry = self.countryData[index]
        }
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
          if pressCancel != nil {
              pressCancel!()
          }
      }
    
      @IBAction func btnOkCLK(_ sender: UIButton) {
        if validationSignUp() {
            let num = txtMobileNo.text!.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
            
            let param = [   "Email": txtEmailId.text!,
                            "Password": txtPassword.text!,
                            "FirstName": txtFirstName.text!,
                            "LastName": txtLastName.text!,
                            "CarrierId": UserInfo.savedUser()!.Id,
                            "PhoneNumber": num,
                            "CountryId": selectedCountry!.Id ] as [String : Any]
            callInsertDriver(url:baseURL+URLS.Drivers_Upsert.rawValue, param) { (data) in
                if let data = data {
                    if self.pressOK != nil {
                        self.pressOK!(data)
                    }
                }
            }
        }
      }
}

extension PopupAddDriverVC : UITextFieldDelegate {
    func validationSignUp() -> Bool
    {
        if  isEmptyString(txtFirstName.text!) || isEmptyString(txtLastName.text!) || isEmptyString(txtCountryCode.text!) || isEmptyString(txtEmailId.text!) || isEmptyString(txtMobileNo.text!) || isEmptyString(txtPassword.text!) || selectedCountry == nil {
            showAlert(popUpMessage.emptyString.rawValue)
            return false
        }
        else{
            return true
        }
    }
    
    //MARK: Textfield Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if txtMobileNo == textField {
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

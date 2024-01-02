//
//  AddContactVC.swift
//  SOS
//
//  Created by Alpesh Desai on 29/12/20.
//

import UIKit

class AddSubUserVC: UIViewController {

    @IBOutlet weak var txtFirstName: LetsTextField!
    @IBOutlet weak var txtLastName: LetsTextField!
    @IBOutlet weak var txtCode: LetsTextField!
    @IBOutlet weak var txtNumber: LetsTextField!
    @IBOutlet weak var txtEmail: LetsTextField!
    @IBOutlet weak var txtPassword: LetsTextField!
    
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
    
    var userData : UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        if let data = self.userData {
            title = "Edit User Account"
            self.txtPassword.isHidden = true
        } else {
            title = "Add User Account"
        }
        callGetCountryList { (datas) in
            self.arrayCountry = datas
            
            if let data = self.userData {
                self.txtPassword.isHidden = true
                self.txtFirstName.text = data.FirstName
                self.txtLastName.text = data.LastName
                self.txtEmail.text = data.Email
                if let country = datas.filter({$0.Id == data.CountryId}).first {
                    let num = data.Mobile.replacingOccurrences(of: "+\(country.CountryCode)", with: "")
                    self.countryData = country
                    self.txtNumber.text = num
                    self.txtCode.text = country.CountryCode
                }
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCodeClk(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: arrayCountry.compactMap({"\($0.CountryCode) (\($0.Name))"})) { (str, index) in
            self.countryData = self.arrayCountry[index]
        }
    }
    
    @IBAction func btnAddContactClk(_ sender: UIButton) {
        self.view.endEditing(true)
        guard let con = self.countryData else {
            return
        }
        if txtNumber.text!.isEmpty {
            showAlert(popUpMessage.PhoneValid.rawValue)
            return
        }
        var param = [
            "ParentCustomer":UserInfo.savedUser()!.Id,//appDelegate.User_Id
            "FirstName":txtFirstName.text!,
            "LastName": txtLastName.text! ,
            "Mobile" : "\(txtNumber.text!)",
            "Password":txtPassword.text!,
            "CountryId":con.Id,
            "Email":txtEmail.text!
        ] as [String : Any]
        if let data = userData {
            param["Id"] = data.Id
        }
        callAddUserDetail(param: param) { (info) in
            if info != nil {
                UsersVC.refresh = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func validationContact() -> Bool
    {
        if  isEmptyString(txtFirstName.text!) || isEmptyString(txtCode.text!) || isEmptyString(txtLastName.text!) || isEmptyString(txtEmail.text!)  {
            showAlert(popUpMessage.emptyString.rawValue)
            return false
        }
        else{
            return true
        }
    }
}


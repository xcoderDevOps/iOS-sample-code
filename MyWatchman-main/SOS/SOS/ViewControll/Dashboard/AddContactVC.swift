//
//  AddContactVC.swift
//  SOS
//
//  Created by Alpesh Desai on 29/12/20.
//

import UIKit

class AddContactVC: UIViewController {

    @IBOutlet weak var txtName: LetsTextField!
    @IBOutlet weak var txtCode: LetsTextField!
    @IBOutlet weak var txtNumber: LetsTextField!
    @IBOutlet weak var txtEmail: LetsTextField!
    @IBOutlet weak var txtrelation: LetsTextField!
    
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
    
    var contactData : ContactData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        title = "Add Contact"
        if let data = contactData {
            title = "Edit Contact"
            txtName.text = data.ContactName
            txtNumber.text = data.ContactPhone
            txtEmail.text = data.ContactEmail
            txtrelation.text = data.Relation
            txtCode.text = data.CountryCode
        }
        
        callGetCountryList { (data) in
            self.arrayCountry = data
            if let con = self.contactData, let selecCon = data.filter({$0.Id == con.Id}).first {
                self.countryData = selecCon
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
    
        if txtNumber.text!.isEmpty {
            showAlert(popUpMessage.PhoneValid.rawValue)
            return
        }
        
        if let coun = self.countryData {
            var param = [   "CustomerId": UserInfo.savedUser()!.Id,
                            "ContactName":txtName.text!,
                            "ContactPhone":txtNumber.text!,
                            "ContactEmail":txtEmail.text!,
                            "Relation":txtrelation.text!,
                            "CountryId":coun.Id ] as [String : Any]
            
            if let con = self.contactData {
                param["Id"] = con.Id
            }
            print(param)
            callAddContatDetail(param: param) { (data) in
                if let data = data {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    func validationContact() -> Bool
    {
        if  isEmptyString(txtName.text!) || isEmptyString(txtCode.text!) || isEmptyString(txtNumber.text!)  {
            showAlert(popUpMessage.emptyString.rawValue)
            return false
        }
        else{
            return true
        }
    }
}


//
//  ProfileVC.swift
//  ECigar
//
//  Created by Alpesh Desai on 23/11/20.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var txtFirstName: LetsFloatField!
    @IBOutlet weak var txtLastName: LetsFloatField!
    @IBOutlet weak var txtEmailId: LetsFloatField!
    @IBOutlet weak var txtMobile: LetsFloatField!
    
    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewCity: UIView!
    
    @IBOutlet weak var txtCountry: LetsFloatField!
    @IBOutlet weak var txtState: LetsFloatField!
    @IBOutlet weak var txtCity: LetsFloatField!
    
    var country = [CountryStateData]()
    var selectedCountry: CountryStateData? {
        didSet {
            if let con = selectedCountry {
                self.txtCountry.text = con.Name
                let url = baseURL + URLS.State_ByCountryId.rawValue + "\(con.Id)"
                callGetCountryStateCity(url) { data in
                    self.state = data
                    self.viewState.isHidden = false
                    if let info = UserInfo.savedUser(), let state = data.filter({$0.Id == info.StateId.ns.integerValue}).first {
                        self.selectedState = state
                    } else {
                        self.viewCity.isHidden = true
                        self.selectedState = nil
                    }
                }
            } else {
                self.txtCountry.text = ""
            }
        }
    }
    
    var state = [CountryStateData]()
    var selectedState : CountryStateData? {
        didSet {
            if let state = selectedState {
                self.txtState.text = state.State
                let url = baseURL + URLS.City_ByStateId.rawValue + "\(state.Id)"
                callGetCountryStateCity(url) { data in
                    self.city = data
                    if let info = UserInfo.savedUser(), let city = data.filter({$0.Id == info.CityId.ns.integerValue}).first {
                        self.selectedCity = city
                    } else {
                        self.selectedCity = nil
                    }
                    self.viewCity.isHidden = false
                }
            } else {
                self.txtState.text = ""
            }
        }
    }
    
    var selectedCity : CountryStateData? {
        didSet {
            if let city = selectedCity {
                self.txtCity.text = city.City
            } else {
                self.txtCity.text = ""
            }
        }
    }
    var city = [CountryStateData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let info = UserInfo.savedUser() else { return }
        
        txtFirstName.text = info.FirstName
        txtLastName.text = info.LastName
        txtEmailId.text = info.Email
        txtMobile.text = info.PhoneNumber
        
        txtCountry.text = info.Country
        txtState.text = info.State
        txtCity.text = info.City
        
        
        self.view.layoutIfNeeded()
        callGetCountryStateCity(baseURL+URLS.Country_All.rawValue) { data in
            self.country = data
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickOnUpdateProfile(_ sender:UIButton) {
        if validationSignUp() {
            
            guard let selectedCountry = selectedCountry else {
                showAlert("Please select country")
                return
            }
            
            guard let selectedState = selectedState else {
                showAlert("Please select state")
                return
            }
            
            guard let selectedCity = selectedCity else {
                showAlert("Please select city")
                return
            }
            
            guard let info = UserInfo.savedUser() else { return }
            let param = [
                "FirstName": txtFirstName.text!,
                "LastName": txtLastName.text!,
                "PhoneNumber": txtMobile.text!,
                "Email":txtEmailId.text!,
                "Id": info.Id,
                "CountryId":selectedCountry.Id,
                "StateId":selectedState.Id,
                "CityId":selectedCity.Id,
                "Country":selectedCountry.Name,
                "State":selectedState.State,
                "City":selectedCity.City
            ] as [String : Any]
            self.view.endEditing(true)
            let url = baseURL + URLS.Users_Upsert.rawValue
            callGetUserUpsert(url, param: param) { data in
                showAlert("Profile updated successfully")
                if let data = data {
                    data.save()
                }
            }
        }
    }
    
    @IBAction func clickOnHelpAndSupport(_ sender:UIButton) {
        let controll = MainBoard.instantiateViewController(withIdentifier: "HelpAndSupportListVC") as! HelpAndSupportListVC
        let root = UINavigationController(rootViewController: controll)
        let bar = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(tapToDismiss))
        root.navigationBar.topItem?.setRightBarButton(bar, animated: true)
        root.modalPresentationStyle = .fullScreen
        appDelegate.window?.rootViewController?.present(root, animated: true, completion: nil)
    }
    
    @objc func tapToDismiss() {
        appDelegate.window?.rootViewController?.dismiss(animated: true)
    }
    
    @IBAction func clickOnChangePassword(_ sender:UIButton) {
        let controll = MainBoard.instantiateViewController(identifier: "ChangePasswordVC") as! ChangePasswordVC
        self.present(controll, animated: true, completion: nil)
    }
    
    @IBAction func clickOnlogout(_ sender:UIButton) {
        alertShow(self, title: "", message: popUpMessage.logoutStr.rawValue, okStr: "Yes", cancelStr: "No", okClick: {
            guard let info = UserInfo.savedUser() else { return }
            self.callLogout(url: baseURL+URLS.Users_Logout.rawValue+"\(info.Id)") { flag in
                if let flag = flag, flag == "true" {
                    UserInfo.clearUser()
                    appDelegate.gotToSigninView()
                }
            }
        }, cancelClick: nil)
    }

    func validationSignUp() -> Bool
    {
        if  isEmptyString(txtFirstName.text!) || isEmptyString(txtLastName.text!) || isEmptyString(txtMobile.text!) {
            showAlert(popUpMessage.emptyString.rawValue)
            return false
        } else{
            return true
        }
    }
    
    
    @IBAction func btnCountryCLK(_ sender:UIButton) {
        let controll = MainBoard.instantiateViewController(withIdentifier: "SingleSelectionVC") as! SingleSelectionVC
        if let con = self.selectedCountry {
            controll.selectedValue = con.Name
        }
        controll.arrayData = country.compactMap({$0.Name})
        controll.completionBlock = { (sender) -> Void in
            if let ac = self.country.filter({$0.Name == sender}).first {
                self.selectedCountry = ac
            }
        }
        self.present(controll, animated: true, completion: nil)
    }
    
    @IBAction func btnStateCLK(_ sender:UIButton) {
        let controll = MainBoard.instantiateViewController(withIdentifier: "SingleSelectionVC") as! SingleSelectionVC
        if let con = self.selectedState {
            controll.selectedValue = con.State
        }
        controll.arrayData = state.compactMap({$0.State})
        controll.completionBlock = { (sender) -> Void in
            if let ac = self.state.filter({$0.State == sender}).first {
                self.selectedState = ac
            }
        }
        self.present(controll, animated: true, completion: nil)
    }
    
    @IBAction func btnCityCLK(_ sender:UIButton) {
        let controll = MainBoard.instantiateViewController(withIdentifier: "SingleSelectionVC") as! SingleSelectionVC
        if let con = self.selectedCity {
            controll.selectedValue = con.City
        }
        controll.arrayData = city.compactMap({$0.City})
        controll.completionBlock = { (sender) -> Void in
            if let ac = self.city.filter({$0.City == sender}).first {
                self.selectedCity = ac
            }
        }
        self.present(controll, animated: true, completion: nil)
    }
}

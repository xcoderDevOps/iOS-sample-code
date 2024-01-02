//
//  RegisterVC.swift
//  TraceableLive
//
//  Created by Alpesh Desai on 02/11/20.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var txtPlanType: LetsFloatField!
    @IBOutlet weak var txtFirstName: LetsFloatField!
    @IBOutlet weak var txtLastName: LetsFloatField!
    @IBOutlet weak var txtEmail: LetsFloatField!
    //@IBOutlet weak var bottomCons: NSLayoutConstraint!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var stackRegister: UIStackView!
    
    @IBOutlet weak var btnGujarat: UIButton!
    @IBOutlet weak var btnHindi: UIButton!

    @IBOutlet weak var viewCountry: UIView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var viewCity: UIView!
    
    @IBOutlet weak var txtCountry: LetsFloatField!
    @IBOutlet weak var txtState: LetsFloatField!
    @IBOutlet weak var txtCity: LetsFloatField!
    
    @IBOutlet weak var lblPaymentMsg: UILabel!
    
    @IBOutlet weak var viewStackPay: UIStackView!
    
    var planList = [PlanDataList]()
    var selectedPlan : PlanDataList?
    
    var completionBlk: (()->())?
    
    
    var country = [CountryStateData]()
    var selectedCountry: CountryStateData? {
        didSet {
            if let con = selectedCountry {
                self.txtCountry.text = con.Name
                let url = baseURL + URLS.State_ByCountryId.rawValue + "\(con.Id)"
                callGetCountryStateCity(url) { data in
                    self.state = data
                    self.viewState.isHidden = false
                    self.viewCity.isHidden = true
                    self.selectedState = nil
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
                    self.viewCity.isHidden = false
                    self.selectedCity = nil
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
        backButton()
        if let info = UserInfo.savedUser(), !info.IsFiestTimeLogin {
            stackRegister.isHidden = true
            self.btnPay.setTitle("Make Payment", for: UIControl.State.normal)
            self.lblPaymentMsg.text = info.IOSDisplayMessage
        }
        // Do any additional setup after loading the view.
        
        self.btnPay.isHidden = true
        self.viewStackPay.isHidden = true
        viewState.isHidden = true
        viewCity.isHidden = true
        self.view.layoutIfNeeded()
        callGetCountryStateCity(baseURL+URLS.Country_All.rawValue) { data in
            self.country = data
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
    
    @IBAction func btnSelectLanguage(_ sender:UIButton) {
        btnHindi.isSelected = false
        btnGujarat.isSelected = false
        sender.isSelected = true
        
        if btnHindi.isSelected {
            self.btnPay.isHidden = false
            self.btnPay.setTitle("Go To Dashboard", for: UIControl.State.normal)
            self.viewStackPay.isHidden = true
        } else {
            self.viewStackPay.isHidden = false
            self.btnPay.isHidden = false
            if let info = UserInfo.savedUser(), !info.IsFiestTimeLogin {
                self.btnPay.setTitle("Make Payment", for: UIControl.State.normal)
            } else {
                self.btnPay.setTitle("Make Payment & Complete Profile", for: UIControl.State.normal)
            }
            
        }
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
    
    
    @IBAction func btnRegisterCLK(_ sender:UIButton) {
        
        if !btnHindi.isSelected && !btnGujarat.isSelected {
            showAlert("Please select language first")
            return
        }

        if btnHindi.isSelected {
            let param = ["Id": 0,
                         "TransactionId": "11",
                         "Time": Date().toString("yyyy-MM-dd'T'HH:mm:ss.SSSZ")!,
                         "LanguageId":btnHindi.isSelected ? 2 : 1,
                         "UserId":UserInfo.savedUser()!.Id ]  as [String:Any]
            
            if !UserInfo.savedUser()!.IsFiestTimeLogin{
                let url = baseURL + URLS.Payment_Upsert.rawValue
                print(param)
                print(url)
                self.callUpsertPayment(url, param: param) { data in
                    print(data)
                    if let data = data {
                        if let info = UserInfo.savedUser() {
                            info.PaymentDateStr = Date().toString("yyyy-MM-dd")!
                            info.save()
                        }
                        if self.completionBlk != nil {
                            self.completionBlk!()
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                
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
                
                
                let param1 = [
                    "Id":UserInfo.savedUser()!.Id,
                    "FirstName": self.txtFirstName.text!,
                    "LastName": self.txtLastName.text!,
                    "Email": self.txtEmail.text!,
                    "CountryId":selectedCountry.Id,
                    "StateId":selectedState.Id,
                    "CityId":selectedCity.Id,
                    "Country":selectedCountry.Name,
                    "State":selectedState.State,
                    "City":selectedCity.City,
                    "LanguageId":self.btnHindi.isSelected ? 2 : 1
                ] as [String : Any]
                
                //"PaymentPlanId": "\(plan.Id)"
                let url = baseURL + URLS.Users_Upsert.rawValue
                self.callGetUserUpsert(url, param: param1) { data in
                    if let data = data {
                        data.save()
                        let url1 = baseURL + URLS.Payment_Upsert.rawValue
                        print(url1)
                        print(param)
                        self.callUpsertPayment(url1, param: param) { data in
                            if data != nil {
                                if let usr = UserInfo.savedUser(), let str = Date().toString("yyyy-MM-dd") {
                                    usr.IsFiestTimeLogin = false
                                    usr.PaymentDateStr = str
                                    usr.save()
                                }
                                if self.completionBlk != nil {
                                    self.completionBlk!()
                                }
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        } else {
            if !UserInfo.savedUser()!.IsFiestTimeLogin{
                
                MakePaymentScreen.shared.makePayment(vc: self) { id in
                    let param = ["Id": 0,
                                 "TransactionId": id,
                                 "UserId": UserInfo.savedUser()!.Id,
                                 "Time": Date().toString("yyyy-MM-dd'T'HH:mm:ss.SSSZ")!,
                                 "LanguageId":self.btnHindi.isSelected ? 2 : 1] as [String:Any]
                    let url = baseURL + URLS.Payment_Upsert.rawValue
                    print(url)
                    print(param)
                    self.callUpsertPayment(url, param: param) { data in
                        if let data = data {
                            if let info = UserInfo.savedUser() {
                                info.PaymentDateStr = Date().toString("yyyy-MM-dd")!
                                info.save()
                            }
                            if self.completionBlk != nil {
                                self.completionBlk!()
                            }
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else if validationSignUp() {
                
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
                
                MakePaymentScreen.shared.makePayment(vc: self) { id in
                    
                    let param1 = [
                        "Id":UserInfo.savedUser()!.Id,
                        "FirstName": self.txtFirstName.text!,
                        "LastName": self.txtLastName.text!,
                        "Email": self.txtEmail.text!,
                        "CountryId":selectedCountry.Id,
                        "StateId":selectedState.Id,
                        "CityId":selectedCity.Id,
                        "Country":selectedCountry.Name,
                        "State":selectedState.State,
                        "City":selectedCity.City,
                        "LanguageId":self.btnHindi.isSelected ? 2 : 1
                    ] as [String : Any]
                    
                    //"PaymentPlanId": "\(plan.Id)"
                    let url1 = baseURL + URLS.Users_Upsert.rawValue
                    self.callGetUserUpsert(url1, param: param1) { data in
                        if let data = data {
                            let param = ["Id": 0,
                                         "TransactionId": id,
                                         "UserId": UserInfo.savedUser()!.Id,
                                         "Time": Date().toString("yyyy-MM-dd'T'HH:mm:ss.SSSZ")!,
                                         "LanguageId":self.btnHindi.isSelected ? 2 : 1] as [String:Any]
                            let url = baseURL + URLS.Payment_Upsert.rawValue
                            print(url)
                            print(param)
                            self.callUpsertPayment(url, param: param) { data in
                                if data != nil {
                                    if let usr = UserInfo.savedUser(), let str = Date().toString("yyyy-MM-dd") {
                                        usr.IsFiestTimeLogin = false
                                        usr.PaymentDateStr = str
                                        usr.save()
                                    }
                                    if self.completionBlk != nil {
                                        self.completionBlk!()
                                    }
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func validationSignUp() -> Bool
    {
        //isEmptyString(txtPlanType.text!)
        if  isEmptyString(txtFirstName.text!) || isEmptyString(txtLastName.text!){
            showAlert(popUpMessage.emptyString.rawValue)
            return false
        } else if !txtEmail.text!.isEmpty && validateEmailWithString(txtEmail.text!) {
            showAlert(popUpMessage.EmailValid.rawValue)
            return false
        }  else{
            return true
        }
    }
    
    @IBAction func btnSelectPlanCLK(_ sender:UIButton) {
        openDropDown(anchorView: sender, data: planList.compactMap({$0.PlanName})) { str, index in
            self.txtPlanType.text = str
            self.selectedPlan = self.planList[index]
        }
    }

}

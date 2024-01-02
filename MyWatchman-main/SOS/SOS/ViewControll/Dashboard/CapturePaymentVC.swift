//
//  CapturePaymentVC.swift
//  SOS
//
//  Created by Alpesh Desai on 01/01/21.
//


import UIKit

class CapturePaymentVC: UIViewController {
    
    @IBOutlet weak var txtCardHolder: LetsFloatField!
    @IBOutlet weak var txtCardNum: LetsFloatField!
    @IBOutlet weak var txtExpiry: LetsFloatField!
    @IBOutlet weak var txtCVV: LetsFloatField!
    @IBOutlet weak var lblPlanDetail: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewSuccess: UIView!
    
    var selectedPlan = PlanListData()

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        title = "CheckOut"
        if selectedPlan.PlanCategory == "Free" {
            let param = [
                            "ExpiryDate":selectedPlan.ExpiryDate,
                            "TransitionDate":selectedPlan.TransitionDate,
                            "Price":selectedPlan.Price,
                            "CustomerId": UserInfo.savedUser()!.Id,
                            "PlanId": selectedPlan.Id
                        ] as [String : Any]
            self.callPostTransectionDetail(param: param) { (data) in
                if let data = data {
                    self.viewSuccess.isHidden = false
                    if let info = UserInfo.savedUser() {
                        self.callGetUserData(baseURL+URLS.GetCustomerById.rawValue+"\(info.Id)") { (info) in
                            if let info = info {
                                info.save()
                            }
                        }
                    }
                }
            }
            viewSuccess.isHidden = false
        } else {
            viewSuccess.isHidden = true
        }
        
        
        lblPlanDetail.text = "Plan Type: \(selectedPlan.PlanCategory)\nPlan Detail: \(selectedPlan.PlanDetails)"
        lblPrice.text = "$\(selectedPlan.Price)"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnExpiryDateCLK(_ sender: UIButton) {
        self.view.endEditing(true)
        _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupMonthYearView", blockOK: { (obj) in
            if let str = obj as? String {
                self.txtExpiry.text = str
            }
            dismissPopUp()
        }, blockCancel: {
            dismissPopUp()
        }, objData: nil)
    }
    
    @IBAction func btnPaymentCLK(_ sender: UIButton) {
        self.view.endEditing(true)
        if txtCardNum.text!.isEmpty || txtCardHolder.text!.isEmpty || txtCVV.text!.isEmpty || txtExpiry.text!.isEmpty {
            showAlert(popUpMessage.emptyString.rawValue)
            return
        }
        
        let param = [
                     "ExpiryDate":selectedPlan.ExpiryDate,
                     "TransitionDate":selectedPlan.TransitionDate,
                     "Price":selectedPlan.Price,
                     "CustomerId": UserInfo.savedUser()!.Id,
                     "PlanId": selectedPlan.Id,
                     "CardNumber": txtCardNum.text!,
                     "CardCvv": txtCVV.text!,
                     "CardMonthYear": txtExpiry.text!
                    ] as [String : Any]
        self.callPostTransectionDetail(param: param) { (data) in
            if let data = data {
                self.viewSuccess.isHidden = false
                if let info = UserInfo.savedUser() {
                    self.callGetUserData(baseURL+URLS.GetCustomerById.rawValue+"\(info.Id)") { (info) in
                        if let info = info {
                            info.save()
                        }
                    }
                }
                
            }
        }
    }
    
    @IBAction func btnHomeCLK(_ sender: UIButton) {
        appDelegate.gotToDashBoardView()
    }
}


extension CapturePaymentVC : UITextFieldDelegate
{
    //MARK: Tex 31254tfield Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField != txtCardHolder
        {
            if string == " " || textField.textInputMode?.primaryLanguage == nil
            {
                return false
            }
        }
        
        if textField == txtCardHolder
        {
            if !string.isCharacter {
                return false
            }
        }
        
        if textField == txtCardNum
        {
            if range.length > 0
            {
                return true
            }
            
            //Dont allow empty strings
            if string == " "
            {
                return false
            }
            
            //Check for max length including the spacers we added
            if range.location == 20
            {
                return false
            }
            
            var originalText = textField.text
            let replacementText = string.replacingOccurrences(of: " ", with: "")
            
            //Verify entered text is a numeric value
            let digits = CharacterSet.decimalDigits
            for char in replacementText.unicodeScalars
            {
                if !digits.contains(UnicodeScalar(char.value)!)
                {
                    return false
                }
            }
            
            //Put an empty space after every 4 places
            if originalText!.ns.length % 5 == 0
            {
                originalText?.append(" ")
                textField.text = originalText
            }
            
        }
        

        
        if textField == txtCVV
        {
            let str : NSString = NSString(format: "%@", txtCVV.text!)
            
            if range.length + range.location > str.length
            {
                return false;
            }
            
            let newLength = str.length + string.ns.length - range.length
            return newLength <= 4
        }
        
        return true
    }
}

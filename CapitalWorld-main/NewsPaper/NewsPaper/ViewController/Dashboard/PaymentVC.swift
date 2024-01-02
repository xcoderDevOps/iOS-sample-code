//
//  PaymentVC.swift
//  NewsPaper
//
//  Created by Alpesh Desai on 09/12/21.
//

import UIKit


class PaymentHistoryCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
}

class PaymentVC: UIViewController {

    @IBOutlet weak var lblPaymentMsg: UILabel!
    
    @IBOutlet weak var lblPlanExpireDate: UILabel!
    @IBOutlet weak var lblTransHistory: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var payData = [PaymentUpsertData]() {
        didSet {
            lblTransHistory.isHidden = payData.isEmpty
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let info = UserInfo.savedUser() else {
            return
        }
        lblTransHistory.isHidden = true
        if let date = info.PaymentDateStr.toDate("yyyy-MM-dd"), let strExDate = date.plusYears(1).toString("EEE, dd MMM yyyy") {
            if date.plusYears(1).plusDays(1) < Date() {
                lblPlanExpireDate.text = "Plan Expired: \(strExDate)\nPaper Language: \(UserInfo.savedUser()!.LanguageId == 2 ? "Hindi" : "Gujarat")"
                lblPlanExpireDate.textColor = UIColor.systemPink
            } else {
                lblPlanExpireDate.text = "Plan Expire On: \(strExDate)\nPaper Language: \(UserInfo.savedUser()!.LanguageId == 2 ? "Hindi" : "Gujarat")"
                lblPlanExpireDate.textColor = UIColor.black
            }
        }
        self.getPaymentData()
        // Do any additional setup after loading the view.
    }
    
    
    func getPaymentData() {
        guard let info = UserInfo.savedUser() else {
            return
        }
        let url = baseURL + URLS.Transaction_ByUserId.rawValue + "\(info.Id)"
        let param = [
            "Offset": 0,
            "Limit": 0,
            "IsOffsetProvided": true,
            "Page": 0,
            "PageSize": 0,
            "SortBy": "string",
            "TotalCount": 0,
            "SortDirection": "string",
            "IsPageProvided": true
        ] as [String : Any]
        callGetTransectionData(url, param: param) { data in
            self.payData = data
            self.tableView.reloadData()
        }
    }
    
    @IBAction func tapOnRenewPlanCLK(sender: UIButton) {
        if UserInfo.savedUser()!.LanguageId == 2 {
            self.openRegistrationPage(info: UserInfo.savedUser()!)
        } else {
            guard let xDate = "31-03-2025".toDate("dd-MM-yyyy") else {
                return
            }
            
            if let info = UserInfo.savedUser(), let payDate = info.PaymentDateStr.toDate("yyyy-MM-dd") {
                let expDate = payDate.plusYears(1)
                if expDate < Date().plusDays(1) {
                    MakePaymentScreen.shared.makePayment(vc: self) { id in
                        let param = ["Id": 0,
                                     "TransactionId": id,
                                     "UserId": UserInfo.savedUser()!.Id,
                                     "Time": Date().toString("yyyy-MM-dd'T'HH:mm:ss.SSSZ")!] as [String:Any]
                        let url = baseURL + URLS.Payment_Upsert.rawValue
                        self.callUpsertPayment(url, param: param) { data in
                            if let info = UserInfo.savedUser() {
                                info.PaymentDateStr = Date().toString("yyyy-MM-dd")!
                            }
                            self.getPaymentData()
                        }
                    }
                } else {
                    showAlert("Your plan not expired yet.")
                }
            }
        }
        
    }
    
    func openRegistrationPage(info: UserInfo) {
        let controll = LoginBord.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        controll.completionBlk = { () -> Void in
            if let info = UserInfo.savedUser() {
                info.PaymentDateStr = Date().toString("yyyy-MM-dd")!
            }
            self.getPaymentData()
        }
        controll.modalPresentationStyle = .fullScreen
        appDelegate.window?.rootViewController?.present(controll, animated: true, completion: nil)
    }
    
}


extension PaymentVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.payData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryCell") as! PaymentHistoryCell
        let obj = self.payData[indexPath.row]
        cell.lblTitle.text = "Transection Id: \(obj.TransactionId)"
        cell.lblDate.text = ""
        if let date = obj.Time.toDate("yyyy-MM-dd'T'HH:mm:ss.SSS"), let str = date.toString("EEE, dd MMM yyyy | hh:mm a") {
            cell.lblDate.text = str
            let xDate = "15-04-2022".toDate("dd-MM-yyyy")!
            let amout = date < xDate ? "₹269.0" : "₹549.0"
            cell.lblAmount.text = amout
        }
        return cell
    }
}


struct SampleAppConstant {
    // API Key that is provided by TraknPay Payament Portal.
    static let API_KEY = "40eebc0f-a80d-4e8f-8dc5-5f34b09e6526"
    
    // Specify the clients web server url to catch the payemnt response
    static let RETURN_URL = "https://capitalworldapi.azurewebsites.net"
    
    // Specify the Payamnet Mode. 1. TEST - Sandbox Mode 2. LIVE - Need to speicfy this one while go LIVE
    static let MODE = "LIVE"
    
    // Specify the Currency value. Only allowed INR
    static let CURRENCY = "INR"
    
    // Specify the Country code. Only allowed IND
    static let COUNTRY = "IND"
    static let NAME = "Manasa"
    static let EMAIL = "fdhaskjdfh@gmail.com"
    static let PHONE = "9892102020"
    static let DESCRIPTION = "Transfer"
    static let CITY = "Mumbai1"
    static let STATE = "Maharashtra"
    static let ADD_1 = "dsfg"
    static let ADD_2 = "Mumbai"
    static let ZIP_CODE = "401107"
    static let UDF_1 = "1"
    static let UDF_2 = "2"
    static let UDF_3 = "3"
    static let UDF_4 = "4"
    static let UDF_5 = "5"
}

extension String{
    var toJSONDictionary: NSDictionary?{
        
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
    
    }
}




//
//  InsurangeInfoVC.swift
//  SOS
//
//  Created by Alpesh Desai on 01/03/21.
//

import UIKit

class InsurangeInfoVC: UIViewController {
    
    @IBOutlet weak var txtPreferHos: LetsTextField!
    @IBOutlet weak var txtHosAddress: LetsTextField!
    @IBOutlet weak var txtPrimaryDoc: LetsTextField!
    @IBOutlet weak var txtPh1: LetsTextField!
    @IBOutlet weak var txtPh2: LetsTextField!
    @IBOutlet weak var txtInsByComp: LetsTextField!
    @IBOutlet weak var txtInsThrough: LetsTextField!

    var arrThrough = ["Self","Family","Work"]
    
    var data = InsuranceData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        title = "Insurance Info"
        
        callGetInsuranceInfo { (data) in
            if let data = data {
                self.data = data
                self.setupData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func setupData() {
        txtPreferHos.text = self.data.HospitalName
        txtHosAddress.text = self.data.HospitalAddress
        txtPrimaryDoc.text = self.data.DoctorName
        let arr = self.data.DoctorPhoneNumber.components(separatedBy: ",")
        for (index, obj) in arr.enumerated() {
            if index == 0 {
                self.txtPh1.text = obj
            }
            if index == 1 {
                txtPh2.text = obj
            }
        }
        txtInsByComp.text = self.data.InsuredBy
        txtInsThrough.text = self.data.InsuredThrough
    }
    
    @IBAction func btnInsuredThroughClk(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: arrThrough) { (str, index) in
            self.txtInsThrough.text = str
        }
    }

    @IBAction func btnSubmitForm(_ sender: UIButton) {
        var mob = [String]()
        if !txtPh1.text!.isEmpty {
            mob.append(txtPh1.text!)
        }
        if !txtPh2.text!.isEmpty {
            mob.append(txtPh2.text!)
        }
        let param = ["Id": UserInfo.savedUser()!.InsuranceId,
                     "CustomerId": UserInfo.savedUser()!.Id,
                     "HospitalName": txtPreferHos.text!,
                     "HospitalAddress": txtHosAddress.text!,
                     "DoctorName":txtPrimaryDoc.text!,
                     "DoctorPhoneNumber":mob.joined(separator: ",") ,
                     "InsuredBy": txtInsByComp.text!,
                     "InsuredThrough": txtInsThrough.text!] as [String : Any]
        print(param)
        callUpsertInsuranceDetail(param: param) { (data) in
            if let data = data {
                if let info = UserInfo.savedUser() {
                    info.InsuranceId = data.Id
                    info.HospitalName = self.txtPreferHos.text!
                    info.HospitalAddress = self.txtHosAddress.text!
                    info.DoctorName = self.txtPrimaryDoc.text!
                    info.DoctorPhoneNumber = mob.joined(separator: ",")
                    info.InsuredBy = self.txtInsByComp.text!
                    info.InsuredThrough = self.txtInsThrough.text!
                    info.save()
    
                }
            }
        }
    }
}

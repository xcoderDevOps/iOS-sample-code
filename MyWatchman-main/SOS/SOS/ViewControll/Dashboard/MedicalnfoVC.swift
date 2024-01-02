//
//  MedicalnfoVC.swift
//  SOS
//
//  Created by Alpesh Desai on 01/03/21.
//

import UIKit

class MedicalnfoVC: UIViewController {

    @IBOutlet weak var txtAge: LetsTextField!
    @IBOutlet weak var txtGender: LetsTextField!
    @IBOutlet weak var txtBloodType: LetsTextField!
    @IBOutlet weak var txtPreExi1: LetsTextField!
    @IBOutlet weak var txtPreExi2: LetsTextField!
    @IBOutlet weak var txtPreExi3: LetsTextField!
    @IBOutlet weak var txtAllergic1: LetsTextField!
    @IBOutlet weak var txtAllergic2: LetsTextField!
    
    @IBOutlet weak var txtWeight: LetsTextField!
    @IBOutlet weak var txtHightFt: LetsTextField!
    @IBOutlet weak var txtHightIn: LetsTextField!
    
    @IBOutlet weak var txtCurrentMedi1: LetsTextField!
    @IBOutlet weak var txtCurrentMedi2: LetsTextField!
    @IBOutlet weak var txtCurrentMedi3: LetsTextField!
    
    var ageArray = ["0–5", "6–10", "11 -16", "17–25", "26–35", "36–45", "46–60", "61 and above"]
    var genderArray = ["Male", "Female", "Other"]
    var bloodArray = ["A+","A-","B+","B-","O+","O-","AB+","AB-"]
    
    
    var data = MedicalInfoData()
                        
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        title = "Medical Info"
        
        callGetMedicalInfo { (data) in
            if let data = data {
                self.data = data
                self.setupData()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func setupData() {
        txtAge.text = self.data.Age
        txtGender.text = self.data.Gender
        txtBloodType.text = self.data.BloodType
        txtWeight.text = self.data.WeightLbs
        txtHightFt.text = self.data.HeightFt
        txtHightIn.text = self.data.HeightIn
        
        txtCurrentMedi1.text = self.data.CurrentMedicationEnterHere1
        txtCurrentMedi2.text = self.data.CurrentMedicationEnterHere2
        txtCurrentMedi3.text = self.data.CurrentMedicationEnterHere3
        
        let arr = self.data.PreExistingCondition.components(separatedBy: ",")
        for (index, obj) in arr.enumerated() {
            if index == 0 {
                txtPreExi1.text = obj
            }
            if index == 1 {
                txtPreExi2.text = obj
            }
            if index == 2 {
                txtPreExi3.text = obj
            }
        }
        
        let arr1 = self.data.AlergicMedicine.components(separatedBy: ",")
        for (index, obj) in arr1.enumerated() {
            if index == 0 {
                txtAllergic1.text = obj
            }
            if index == 1 {
                txtAllergic2.text = obj
            }
        }
    }
    
    @IBAction func btnTapOnAge(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: ageArray) { (str, index) in
            self.txtAge.text = str
        }
    }
    
    @IBAction func btnTapOnGender(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: genderArray) { (str, index) in
            self.txtGender.text = str
        }
    }
    
    @IBAction func btnTapOnBloodType(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: bloodArray) { (str, index) in
            self.txtBloodType.text = str
        }
    }

    @IBAction func btnSubmitForm(_ sender: UIButton) {
        var preExi = [String]()
        if !txtPreExi1.text!.isEmpty {
            preExi.append(txtPreExi1.text!)
        }
        if !txtPreExi2.text!.isEmpty {
            preExi.append(txtPreExi2.text!)
        }
        if !txtPreExi3.text!.isEmpty {
            preExi.append(txtPreExi3.text!)
        }
        
        var txtAlle = [String]()
        if !txtAllergic1.text!.isEmpty {
            txtAlle.append(txtAllergic1.text!)
        }
        if !txtAllergic2.text!.isEmpty {
            txtAlle.append(txtAllergic2.text!)
        }
        let param = ["Id": UserInfo.savedUser()!.MedicalId,
                     "CustomerId": UserInfo.savedUser()!.Id,
                     "Age": txtAge.text!,
                     "Gender": txtGender.text!,
                     "BloodType": txtBloodType.text!,
                     "WeightLbs":txtWeight.text!,
                     "HeightFt":txtHightFt.text!,
                     "HeightIn":txtHightIn.text!,
                     "PreExistingCondition": preExi.joined(separator: ","),
                     "AlergicMedicine": txtAlle.joined(separator: ","),
                     "CurrentMedicationEnterHere1":txtCurrentMedi1.text!,
                     "CurrentMedicationEnterHere2":txtCurrentMedi2.text!,
                     "CurrentMedicationEnterHere3":txtCurrentMedi3.text! ] as [String : Any]
        
        callUpsertMedicalDetail(param: param) { (data) in
            if let data = data {
                if let info = UserInfo.savedUser() {
                    info.MedicalId = data.Id
                    info.Age = self.txtAge.text!
                    info.Gender = self.txtGender.text!
                    info.BloodType = self.txtBloodType.text!
                    info.PreExistingCondition = preExi.joined(separator: ",")
                    info.AlergicMedicine = txtAlle.joined(separator: ",")
                    info.save()
                }
            }
        }
    }
}

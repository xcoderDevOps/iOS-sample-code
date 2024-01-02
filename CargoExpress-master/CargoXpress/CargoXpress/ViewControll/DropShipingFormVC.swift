//
//  MakeAppointmentVC.swift
//  GoldClean
//
//  Created by infolabh on 21/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import GMStepper

class DropShipingFormVC: UIViewController {

    @IBOutlet weak var txtSourceHomeNo: LetsFloatField!
    @IBOutlet weak var txtSourceLandmark: LetsFloatField!
    @IBOutlet weak var txtSourcePostalCode: LetsFloatField!
    @IBOutlet weak var txtSourceCity: LetsFloatField!
    @IBOutlet weak var txtSourcePhoneNum: LetsFloatField!
    
    @IBOutlet weak var txtDestiHomeNo: LetsFloatField!
    @IBOutlet weak var txtDestiLandmark: LetsFloatField!
    @IBOutlet weak var txtDestiPostalCode: LetsFloatField!
    @IBOutlet weak var txtDestiCity: LetsFloatField!
    @IBOutlet weak var txtDestiPhoneNum: LetsFloatField!
    
    @IBOutlet weak var txtGoodName: LetsFloatField!
    @IBOutlet weak var txtWeight: LetsFloatField!
    @IBOutlet weak var txtDate: LetsFloatField!
    @IBOutlet weak var txtInstruction: LetsFloatField!
    
    @IBOutlet weak var switchIsFargile: UISwitch!
    @IBOutlet weak var switchIsExpress: UISwitch!
    @IBOutlet weak var numOfContainer: GMStepper!
    
    
    //@IBOutlet weak var txtHomeNo: LetsFloatField!
    
    
    @IBOutlet weak var firstPage: LetsView!
    @IBOutlet weak var secondPage: LetsView!
    @IBOutlet weak var thirdPage: LetsView!
    
    @IBOutlet weak var btnBackPage: UIButton!
    @IBOutlet weak var btnNextPage: UIButton!
    @IBOutlet weak var pageNumber: UIPageControl!
    
    struct ExtraData {
        var title = ""
        var flag = false
    }
    
    var arrayExtraData = [ExtraData]()
    
    var pickerArrayData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home Cleaning"
        backButton(color: UIColor.white)
        
        self.btnBackPage.isHidden = true
        secondPage.isHidden = true
        thirdPage.isHidden = true
        
    }
    
    @IBAction func btnOpenDatePickerClk(_ sender: UIButton) {
        self.openDatePicker(formate: "dd MMM yyyy") { (str) in
            self.txtDate.text = str
        }
    }
    
    @IBAction func btnbackPageClk(_ sender: UIButton) {
        self.btnBackPage.isHidden = false
        firstPage.isHidden = true
        secondPage.isHidden = true
        thirdPage.isHidden = true
        btnNextPage.setTitle("NEXT  ", for: UIControl.State.normal)
        switch pageNumber.currentPage {
        case 0:
            break
        case 1:
            self.btnBackPage.isHidden = true
            pageNumber.currentPage = 0
            firstPage.isHidden = false
            break
        case 2:
            pageNumber.currentPage = 1
            secondPage.isHidden = false
            break
        default:
            break
        }
        
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnNextPageClk(_ sender: UIButton) {
        
        self.btnBackPage.isHidden = false
        firstPage.isHidden = true
        secondPage.isHidden = true
        thirdPage.isHidden = true
        switch pageNumber.currentPage {
        case 0:
            pageNumber.currentPage = 1
            secondPage.isHidden = false
            btnNextPage.setTitle("NEXT  ", for: UIControl.State.normal)
            break
        case 1:
            btnNextPage.setTitle("COMPLETE  ", for: UIControl.State.normal)
            pageNumber.currentPage = 2
            thirdPage.isHidden = false
            break
        case 2:
            //Call API With Complete Detail Filled
            thirdPage.isHidden = false
            let controll = MainBoard.instantiateViewController(identifier: "JobInformationVC") as! JobInformationVC
            self.navigationController?.pushViewController(controll, animated: true)
            break
        default:
            break
        }
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
        }
    }
}


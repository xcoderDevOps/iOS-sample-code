//
//  AddExtraAddressDetailVC.swift
//  Bindle
//
//  Created by Bindle Ilc. on 20/07/16.
//  Copyright © 2016 Bindle Ilc.. All rights reserved.
//

import UIKit

import GMStepper


class AddExtraAddressDetailVC: UIViewController, UITextViewDelegate {

    //MARK: - Variable declaration -
    
    @IBOutlet weak var txtTruckType: LetsTextField!
    @IBOutlet weak var txtServiceType: LetsTextField!
    
    @IBOutlet weak var txtTotalPallet: LetsFloatField!
    @IBOutlet weak var txtCBM: LetsFloatField!
    @IBOutlet weak var txtDeliverItem: LetsFloatField!
    @IBOutlet weak var txtHsCode: LetsFloatField!
    @IBOutlet weak var txtCommodityType: LetsFloatField!
    @IBOutlet weak var txtActualTnge: LetsFloatField!
    @IBOutlet weak var txtCars: LetsFloatField!
    
    @IBOutlet weak var txtLiter: LetsFloatField!
    @IBOutlet weak var txtCubicMeter: LetsFloatField!
    
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var switchIsFargile: UISwitch!
    @IBOutlet weak var switchIsExpress: UISwitch!

    @IBOutlet weak var txtInstruction: LetsFloatField!
    @IBOutlet weak var txtExpressDate: LetsTextField!
    
    @IBOutlet weak var viewNoOfCon: UIView!
    @IBOutlet weak var viewCBM: UIView!
    @IBOutlet weak var viewTotalPallet: UIView!
    @IBOutlet weak var viewAct: UIView!
    @IBOutlet weak var viewComodity: UIView!
    @IBOutlet weak var viewHS: UIView!
    @IBOutlet weak var viewConHeight: UIView!
    @IBOutlet weak var viewDeliveryItem: UIView!
    @IBOutlet weak var viewCars: UIView!
    @IBOutlet weak var segmentHeight: UISegmentedControl!
    @IBOutlet weak var viewExpress: UIView!
    
    @IBOutlet weak var viewLiter: UIView!
    @IBOutlet weak var viewCubicMeter: UIView!
    
    @IBOutlet weak var btnCrossBorder: UIButton!
    @IBOutlet weak var btnLocalFrieght: UIButton!
    
    var serviceTypes = [ServiceTypeData]()
    
   //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton(color: UIColor.white)
        title = "Address Details"
    
        viewExpress.isHidden = true
        self.txtTruckType.text = distanceDateTime.truckType.Name
        if startAddress.country == endAddress.country {
            btnLocalFrieght.isSelected = true
        } else {
            btnCrossBorder.isSelected = true
        }
        
        if distanceDateTime.truckType.Name == "Semi Trailer Truck" || distanceDateTime.truckType.Name == "Tanker Truck"
            || distanceDateTime.truckType.Name == "Heavy Trailer Truck" || distanceDateTime.truckType.Name == "Box Truck" || distanceDateTime.truckType.Name == "Flatbed Truck" || distanceDateTime.truckType.Name == "Car Transporter" || distanceDateTime.truckType.Name == "Refrigerator Truck" {
            btnCrossBorder.isHidden = false
        }
        if distanceDateTime.truckType.Name == "Car Transporter" {
            btnLocalFrieght.isHidden = true
        }
        hideAllView()
        callGetServiceTypeList(id: distanceDateTime.truckType.Id) { (data) in
            self.serviceTypes = data
            if let firt = self.serviceTypes.first {
                distanceDateTime.serviceType = firt
                self.txtServiceType.text = firt.Name
                self.changeSelectionForType(serviceType: distanceDateTime.serviceType.Name)
            }
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnTruckTypeClk(_ sender: UIButton) {
//        let arr = DashboardVC.truckTypeArray.compactMap({$0.Name})
//        openDropDown(anchorView: sender, data: arr) { (str, index) in
//            self.txtTruckType.text = DashboardVC.truckTypeArray[index].Name
//            distanceDateTime.truckType = DashboardVC.truckTypeArray[index]
//
//            self.btnCrossBorder.isHidden = true
//            self.btnCrossBorder.isSelected = false
//            self.btnLocalFrieght.isSelected = false
//            if distanceDateTime.truckType.Name == "Semi Trailer Truck" || distanceDateTime.truckType.Name == "Tanker Truck"
//                || distanceDateTime.truckType.Name == "Heavy Trailer Truck" || distanceDateTime.truckType.Name == "Box Truck" || distanceDateTime.truckType.Name == "Flatbed Truck" || distanceDateTime.truckType.Name == "Car Transporter" || distanceDateTime.truckType.Name == "Refrigerator Truck" {
//                self.btnCrossBorder.isHidden = false
//                self.btnCrossBorder.isSelected = true
//            } else {
//                self.btnLocalFrieght.isSelected = true
//            }
//        }
    }
    
    
    func hideAllView() {
        viewNoOfCon.isHidden = true
        viewCBM.isHidden = true
        viewTotalPallet.isHidden = true
        viewAct.isHidden = true
        viewComodity.isHidden = true
        viewHS.isHidden = true
        viewConHeight.isHidden = true
        viewDeliveryItem.isHidden = true
        viewLiter.isHidden = true
        viewCubicMeter.isHidden = true
        viewCars.isHidden = true
    }
    
    @IBAction func btnServiceTypeCLK(_ sender: UIButton) {
        hideAllView()
        let arr = serviceTypes.compactMap({$0.Name})
        openDropDown(anchorView: sender, data: arr) { (str, index) in
            self.txtServiceType.text = self.serviceTypes[index].Name
            distanceDateTime.serviceType = self.serviceTypes[index]
            self.changeSelectionForType(serviceType: self.serviceTypes[index].Name)
        }
    }
    
    @IBAction func btnCrosBorderLocalSelect(_ sender: UIButton) {
        hideAllView()
        btnCrossBorder.isSelected = false
        btnLocalFrieght.isSelected = false
        sender.isSelected = true
        self.changeSelectionForType(serviceType: distanceDateTime.serviceType.Name)
    }
    
    
    func changeSelectionForType(serviceType:String) {
        switch distanceDateTime.truckType.Name {
        case "Semi Trailer Truck":
            switch serviceType {
            case "FCL":
                if self.btnCrossBorder.isSelected {
                    self.viewNoOfCon.isHidden = false
                    self.viewAct.isHidden = false
                    self.viewHS.isHidden = false
                    self.viewComodity.isHidden = false
                } else {
                    self.viewNoOfCon.isHidden = false
                    self.viewAct.isHidden = false
                    self.viewDeliveryItem.isHidden = false
                }
                
                break
            case "FTL":
                if self.btnCrossBorder.isSelected {
                    self.viewAct.isHidden = false
                    self.viewTotalPallet.isHidden = false
                    self.viewHS.isHidden = false
                    self.viewComodity.isHidden = false
                } else {
                    self.viewAct.isHidden = false
                    self.viewDeliveryItem.isHidden = false
                }
                break
            case "LTL":
                if self.btnCrossBorder.isSelected {
                    self.viewAct.isHidden = false
                    self.viewTotalPallet.isHidden = false
                    self.viewHS.isHidden = false
                    self.viewComodity.isHidden = false
                    self.viewCBM.isHidden = false
                } else {
                    self.viewAct.isHidden = false
                    self.viewDeliveryItem.isHidden = false
                    self.viewCBM.isHidden = false
                }
                
                break
            default:
                break
            }
            break
        case "Tanker Truck":
            if self.btnCrossBorder.isSelected {
                self.viewCubicMeter.isHidden = false
                self.viewLiter.isHidden = false
                self.txtLiter.text = "Liters (optional)"
                self.viewAct.isHidden = false
                self.viewTotalPallet.isHidden = false
                self.viewHS.isHidden = false
                self.viewComodity.isHidden = false
            } else {
                self.viewCubicMeter.isHidden = false
                self.viewLiter.isHidden = false
                self.viewDeliveryItem.isHidden = false
                
            }
            break
        case "Heavy Trailer Truck":
            switch serviceType {
            case "FCL":
                if self.btnCrossBorder.isSelected {
                    self.viewNoOfCon.isHidden = false
                    self.viewAct.isHidden = false
                    self.viewTotalPallet.isHidden = false
                    self.viewHS.isHidden = false
                    self.viewComodity.isHidden = false
                } else {
                    self.viewNoOfCon.isHidden = false
                    self.viewAct.isHidden = false
                    self.viewDeliveryItem.isHidden = false
                }
                
                break
            case "FTL":
                if self.btnCrossBorder.isSelected {
                    self.viewAct.isHidden = false
                    self.viewTotalPallet.isHidden = false
                    self.viewHS.isHidden = false
                    self.viewComodity.isHidden = false
                } else {
                    self.viewAct.isHidden = false
                    self.viewDeliveryItem.isHidden = false
                }
                break
            case "LTL":
                if self.btnCrossBorder.isSelected {
                    self.viewAct.isHidden = false
                    self.viewTotalPallet.isHidden = false
                    self.viewHS.isHidden = false
                    self.viewComodity.isHidden = false
                    self.viewCBM.isHidden = false
                } else {
                    self.viewAct.isHidden = false
                    self.viewDeliveryItem.isHidden = false
                    self.viewCBM.isHidden = false
                }
                
                break
            default:
                break
            }
            
            break
        case "Box Truck":
            switch serviceType {
            case "FCL":
                self.viewNoOfCon.isHidden = false
                self.viewAct.isHidden = false
                self.viewTotalPallet.isHidden = false
                self.viewHS.isHidden = false
                self.viewComodity.isHidden = false
                break
            case "FTL":
                self.viewAct.isHidden = false
                self.viewTotalPallet.isHidden = false
                self.viewHS.isHidden = false
                self.viewComodity.isHidden = false
                break
            case "LTL":
                self.viewAct.isHidden = false
                self.viewTotalPallet.isHidden = false
                self.viewHS.isHidden = false
                self.viewComodity.isHidden = false
                self.viewCBM.isHidden = false
                break
            default:
                self.viewAct.isHidden = false
                self.viewCBM.isHidden = false
                self.viewDeliveryItem.isHidden = false
                self.txtCBM.placeholder = "CBM (Optional)"
                break
            }
            break
        case "Flatbed Truck":
            switch serviceType {
            case "FCL":
                if self.btnCrossBorder.isSelected {
                    self.viewNoOfCon.isHidden = false
                    self.viewAct.isHidden = false
                    self.viewTotalPallet.isHidden = false
                    self.viewHS.isHidden = false
                    self.viewComodity.isHidden = false
                } else {
                    self.viewNoOfCon.isHidden = false
                    self.viewAct.isHidden = false
                    self.viewDeliveryItem.isHidden = false
                }
                
                break
            case "FTL":
                if self.btnCrossBorder.isSelected {
                    self.viewAct.isHidden = false
                    self.viewTotalPallet.isHidden = false
                    self.viewHS.isHidden = false
                    self.viewComodity.isHidden = false
                } else {
                    self.viewAct.isHidden = false
                    self.viewDeliveryItem.isHidden = false
                }
                break
            case "LTL":
                if self.btnCrossBorder.isSelected {
                    self.viewAct.isHidden = false
                    self.viewTotalPallet.isHidden = false
                    self.viewHS.isHidden = false
                    self.viewComodity.isHidden = false
                    self.viewCBM.isHidden = false
                } else {
                    self.viewAct.isHidden = false
                    self.viewDeliveryItem.isHidden = false
                    self.viewCBM.isHidden = false
                }
                
                break
            default:
                break
            }
            break
        case "Car Transporter":
            self.viewCars.isHidden = false
            break
        case "Refrigerator Truck":
            self.viewAct.isHidden = false
            self.viewTotalPallet.isHidden = false
            self.viewHS.isHidden = false
            self.viewComodity.isHidden = false
            if !self.btnCrossBorder.isSelected {
                self.viewDeliveryItem.isHidden = false
            }
            break
        case "Motorbike":
            self.txtCars.placeholder = "Kg"
            self.viewCars.isHidden = false
            self.viewDeliveryItem.isHidden = false
            break
        case "Dumper Truck":
            self.viewAct.isHidden = false
            self.viewCBM.isHidden = false
            self.txtCBM.placeholder = "CBM (Optional)"
            self.viewDeliveryItem.isHidden = false
            break
        case "Tricycle":
            self.viewAct.isHidden = false
            self.viewCBM.isHidden = false
            self.txtCBM.placeholder = "CBM (Optional)"
            self.viewDeliveryItem.isHidden = false
            break
        case "Pickup":
            self.viewAct.isHidden = false
            self.viewCBM.isHidden = false
            self.txtCBM.placeholder = "CBM (Optional)"
            self.viewDeliveryItem.isHidden = false
            break
        default:
            self.viewAct.isHidden = false
            self.viewCBM.isHidden = false
            self.txtCBM.placeholder = "CBM (Optional)"
            self.viewDeliveryItem.isHidden = false
            break
        }
    }
    
    @IBAction func switchExpressCLK(_ sender: UISwitch) {
        viewExpress.isHidden = !sender.isOn
        if sender.isOn == false {
            distanceDateTime.expressDate = ""
        }
    }
    
    
    @IBAction func btnExpressDateClk(_ sender: UIButton) {
        self.openDatePicker(formate: "dd-MMM-yyyy") { (str) in
            self.txtExpressDate.text = str
            distanceDateTime.expressDate = str
            
        }
    }
    /**
     Fill Up Add Data Using bellow action
     after click on continue go to next screen
     - important: Form Fill
     - returns: false
     - parameter sender:
     - - -
     [Bindle Inc.](https://www.getbindle.com/)
     - - -
     */

    @IBAction func btnContinueClk(_ sender: UIButton) {
        distanceDateTime.extraInstruction = txtInstruction.text!
        distanceDateTime.totalPallet = txtTotalPallet.text!
        distanceDateTime.CBM = txtCBM.text!
        distanceDateTime.HS = txtHsCode.text!
        distanceDateTime.Commodity = txtCommodityType.text!
        distanceDateTime.actualTonnge = txtActualTnge.text!
        distanceDateTime.isFargile = switchIsFargile.isOn
        distanceDateTime.isExpress = switchIsFargile.isOn
        distanceDateTime.noOfContainer = stepper.value
        distanceDateTime.containerHeight = segmentHeight.selectedSegmentIndex == 0 ? "20ft" : "40ft"
        distanceDateTime.IsCrossBorder = btnCrossBorder.isSelected
        distanceDateTime.deliverItem = txtDeliverItem.text!
        distanceDateTime.liter = txtLiter.text!
        distanceDateTime.cubicMeter = txtCubicMeter.text!
        if distanceDateTime.serviceType.Name == "Motorbike" {
            distanceDateTime.kg = txtCars.text!
        } else {
            distanceDateTime.cars = txtCars.text!
        }
        
        if distanceDateTime.isExpress {
            if distanceDateTime.expressDate.isEmpty {
                showAlert("Please select express date")
                return
            }
        }
        
        let controll = MainBoard.instantiateViewController(identifier: "JobInformationVC") as! JobInformationVC
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
}

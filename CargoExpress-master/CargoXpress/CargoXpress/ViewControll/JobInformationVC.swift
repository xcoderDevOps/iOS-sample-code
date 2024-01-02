//
//  JobInformationVC.swift
//  GoldClean
//
//  Created by infolabh on 20/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class JobInformationVC: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblFregile: UILabel!
    @IBOutlet weak var lblExpress: UILabel!
    @IBOutlet weak var lblContainers: UILabel!
    @IBOutlet weak var lblActualTon: UILabel!
    @IBOutlet weak var lblHsCode: UILabel!
    @IBOutlet weak var lblCBM: UILabel!
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var lblTotalPallet: UILabel!
    @IBOutlet weak var lblCommodity: UILabel!
    @IBOutlet weak var lblpickUp: UILabel!
    @IBOutlet weak var lblDrop: UILabel!
    @IBOutlet weak var stackMsg: UIStackView!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblExpressDate: UILabel!
    @IBOutlet weak var stackExpress: UIStackView!
    @IBOutlet weak var stackCommodity: UIStackView!
    @IBOutlet weak var staclTotalPalate: UIStackView!
    @IBOutlet weak var stackContainer: UIStackView!
    @IBOutlet weak var stackCBM: UIStackView!
    
    @IBOutlet weak var stackCubicMeter: UIStackView!
    @IBOutlet weak var stackLiter: UIStackView!
    @IBOutlet weak var stackCars: UIStackView!
    
    @IBOutlet weak var lblCubicMeter: UILabel!
    @IBOutlet weak var lblLiter: UILabel!
    @IBOutlet weak var lblCarsKgTitle: UILabel!
    @IBOutlet weak var lblCarsKg: UILabel!
    @IBOutlet weak var lblDeliveryItems: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Confirm"
        backButton(color: UIColor.white)
        
        lblDate.text = distanceDateTime.PickupDate.isEmpty ? "--" : distanceDateTime.PickupDate
        lblType.text = distanceDateTime.truckType.Name.isEmpty ? "--" : distanceDateTime.truckType.Name
        lblFregile.text = distanceDateTime.isFargile ? "Yes" : "No"
        lblExpress.text = distanceDateTime.isExpress ? "Yes" : "No"
        lblContainers.text = "\(Int(distanceDateTime.noOfContainer)) (\(distanceDateTime.containerHeight))"
        lblActualTon.text = distanceDateTime.actualTonnge.isEmpty ? "--" : distanceDateTime.actualTonnge
            lblHsCode.text = distanceDateTime.HS.isEmpty ? "--" : distanceDateTime.HS
            lblCBM.text = distanceDateTime.CBM.isEmpty ? "--" : distanceDateTime.CBM
            lblServiceType.text = distanceDateTime.serviceType.Name.isEmpty ? "--" : distanceDateTime.serviceType.Name
        //staclTotalPalate.isHidden = distanceDateTime.totalPallet.isEmpty
            lblTotalPallet.text = distanceDateTime.totalPallet.isEmpty ? "--" : distanceDateTime.totalPallet
            lblCommodity.text = distanceDateTime.Commodity.isEmpty ? "--" : distanceDateTime.Commodity
        //stackCommodity.isHidden = distanceDateTime.Commodity.isEmpty
        lblpickUp.text = startAddress.address
        lblDrop.text = endAddress.address
        lblComment.text = distanceDateTime.extraInstruction.isEmpty ? "--" : distanceDateTime.extraInstruction
        lblExpress.text = distanceDateTime.expressDate.isEmpty ? "--" : distanceDateTime.expressDate
        
        //stackExpress.isHidden = !distanceDateTime.isExpress
        //stackMsg.isHidden = distanceDateTime.extraInstruction.isEmpty
        //stackContainer.isHidden = distanceDateTime.noOfContainer == 0.0
        //stackCBM.isHidden = distanceDateTime.CBM.isEmpty
        
        lblCubicMeter.text = distanceDateTime.cubicMeter.isEmpty ? "--" : distanceDateTime.cubicMeter
        lblLiter.text = distanceDateTime.liter.isEmpty ? "--" : distanceDateTime.liter
        if distanceDateTime.serviceType.Name == "Motorbike" {
            lblCarsKgTitle.text = "Cars"
            lblCarsKg.text = distanceDateTime.cars.isEmpty ? "--" : distanceDateTime.cars
        } else {
            lblCarsKgTitle.text = "Kg"
            lblCarsKg.text = (distanceDateTime.kg.isEmpty  || distanceDateTime.kg == "0") ? "--" : distanceDateTime.kg
        }
        
        lblDeliveryItems.text = distanceDateTime.deliverItem.isEmpty ? "--" : distanceDateTime.deliverItem
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnConfirmAndOay(_ sender: UIButton) {
        var id = 0
        if appDelegate.isFindService {
            id = UserInfo.savedUser()!.Id
        } else {
            if let sId = carrierSideShipperId {
                id = sId
            }
            
        }
        
        let param = [ "ShipperId": id,
                    "NoOfContainer": Int(distanceDateTime.noOfContainer),
                    "ActualTonage": distanceDateTime.actualTonnge,
                    "TotalPallets": distanceDateTime.totalPallet,
                    "Cbm": distanceDateTime.CBM,
                    "CommodityType": distanceDateTime.Commodity,
                    "HsCode": distanceDateTime.HS,
                    "SpecialMessage": distanceDateTime.extraInstruction,
                    "IsFargile": distanceDateTime.isFargile,
                    "IsExpres": distanceDateTime.isExpress,
                    "PickUpAddressLongitude": startAddress.long,
                    "PickUpAddressLatitude": startAddress.lat,
                    "PickUpAddress": startAddress.locationType.Name + " - " + startAddress.address,
                    "DropOffAddress": endAddress.locationType.Name + " - " + endAddress.address,
                    "DropOffAddressLongitude": endAddress.long,
                    "DropOffAddressLatitude": endAddress.lat ,
                    "TruckTypeId": distanceDateTime.truckType.Id,
                    "TruckServiceId": distanceDateTime.serviceType.Id,
                    "ExpressDate":distanceDateTime.expressDate,
                    "Distance":distanceDateTime.distance.ns.doubleValue,
                    "PickupDate": distanceDateTime.PickupDate,
                    "TruckLength":distanceDateTime.containerHeight,
                    "CubicMeter": distanceDateTime.cubicMeter,
                    "Liters": distanceDateTime.liter,
                    "Cars": distanceDateTime.cars,
                    "DeliveryItem": distanceDateTime.deliverItem,
                    "IsCrossBorder": distanceDateTime.IsCrossBorder,
                    "Kg": distanceDateTime.kg] as [String : Any]
        callAddJob(url: baseURL+URLS.Job_Insert.rawValue, param) { (jobData) in
            if let jobData = jobData {
                if appDelegate.isFindService {
                    showAlert("Job placed successfully")
                    leftSideMenu?.didselectTableViewCellAtIndex(index: 1)
                } else {
                    
                    _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupChangeBidVC", blockOK: { (obj) in
                        dismissPopUp()
                        if let data = obj as? JobBidData {
                            let controll = MainBoard.instantiateViewController(identifier: "JobPaymentVC") as! JobPaymentVC
                            controll.jobData = jobData
                            controll.jobBidData = data
                            self.navigationController?.pushViewController(controll, animated: true)
                        }
                    }, blockCancel: {
                        dismissPopUp()
                    }, objData: jobData as AnyObject)
                }
                
            }
        }
    }
    
}


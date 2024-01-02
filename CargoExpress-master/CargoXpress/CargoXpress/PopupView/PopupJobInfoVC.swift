//
//  PopupJobInfoVC.swift
//  CargoXpress
//
//  Created by infolabh on 09/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class PopupJobInfoVC: MyPopupController {
    
    @IBOutlet weak var lblJobInfo: UILabel!
    @IBOutlet weak var lblJobNo: UILabel!
    @IBOutlet weak var lblCarrierType: UILabel!
    @IBOutlet weak var lblPickup: UILabel!
    @IBOutlet weak var lblDrop: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var jobData = JobData()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let obj = objData as? JobData {
            self.jobData = obj
            updateUI()
            getJobFromAPI()
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func getJobFromAPI() {
        callGetJobDataFromjobID(url: baseURL+URLS.Job_ById.rawValue+"\(jobData.Id)") { (data) in
            if let data = data {
                self.jobData = data
                self.updateUI()
            }
        }
    }
    
    func updateUI() {
        lblCarrierType.text = jobData.TruckType
        lblJobNo.text = "Job No: \(jobData.JobNo)"
        
        var arrayData = [String]()
        
        arrayData.append("Service Type: \(jobData.TruckService)")
        if jobData.TotalPallets > 0 {
            arrayData.append("Total Pallets: \(jobData.TotalPallets)")
        }
        if jobData.Cbm > 0 {
            arrayData.append("CBM: \(jobData.TotalPallets)")
        }
        
        if !jobData.HsCode.isEmpty {
            arrayData.append("HS Code: \(jobData.HsCode)")
        }
        
        if !jobData.CommodityType.isEmpty {
            arrayData.append("Commodity Type: \(jobData.CommodityType)")
        }
        
        if jobData.ActualTonage > 0 {
            arrayData.append("Actual Tonnage: \(jobData.ActualTonage)")
        }
        arrayData.append("Fargile: \(jobData.IsFargile ? "Yes" : "No")")
        arrayData.append("Express: \(jobData.IsExpres ? "Yes" : "No")")
        if jobData.IsExpres {
            arrayData.append("Express Date:\(jobData.ExpressDate)")
        }
        if jobData.NoOfContainer > 0 {
            arrayData.append("No Of Container: \(jobData.NoOfContainer)")
        }
        if !jobData.TruckLength.isEmpty {
            arrayData.append("Container Height: \(jobData.TruckLength)")
        }
        if jobData.IsCrossBorder {
            arrayData.append("Freight: \(jobData.IsCrossBorder ? "Cross Border"  : "Local")")
        }
        if !jobData.CubicMeter.isEmpty {
            arrayData.append("Cubic Meter: \(jobData.CubicMeter)")
        }
        if !jobData.Liters.isEmpty {
            arrayData.append("Liters: \(jobData.Liters)")
        }
        if !jobData.Cars.isEmpty {
            arrayData.append("Cars: \(jobData.Cars)")
        }
        if !jobData.Kg.isEmpty  && jobData.Kg != "0"{
            arrayData.append("Kg: \(jobData.Kg)")
        }
        if !jobData.DeliveryItem.isEmpty {
            arrayData.append("DeliveryItem: \(jobData.DeliveryItem)")
        }
        lblJobInfo.text = arrayData.joined(separator: "\n")
        lblPickup.text = jobData.PickUpAddress
        lblDrop.text = jobData.DropOffAddress
        lblAmount.text = String(format: "%.2f", jobData.JobAmount)
        
        lblDate.text = "--"
        if let dateStr = jobData.PickupDate.components(separatedBy: " ").first {
            lblDate.text = "\(dateStr)"
        }
        
        lblDistance.text = "--"
        if jobData.Distance > 0.0 {
            lblDistance.text = String(format: "%.2f Km", jobData.Distance)
        }
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        if pressCancel != nil {
            pressCancel!()
        }
    }
}

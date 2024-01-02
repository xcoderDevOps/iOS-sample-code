//
//  JobFilterVC.swift
//  CargoXpress
//
//  Created by Alpesh Desai on 02/10/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

struct FilterData {
    var pickupId = ""
    var dropId = ""
    var serviceTypeId = ""
    var pickupDate = ""
    var startDate = ""
    var endDate = ""
    var IsJobWithIssues = ""
}

class JobFilterVC: UIViewController {

    @IBOutlet weak var txtPickup: LetsFloatField!
    @IBOutlet weak var txtDropup: LetsFloatField!
    @IBOutlet weak var txtTruckService: LetsFloatField!
    @IBOutlet weak var txtPickupDate: LetsFloatField!
    @IBOutlet weak var txtStartDate: LetsFloatField!
    @IBOutlet weak var txtEndDate: LetsFloatField!
    
    @IBOutlet weak var switchIssue: UISwitch!
    var applyFilterData : FilterData?
    var countryData = [CountryData]()
    
    var completionBlock : ((_ data: FilterData?)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton(color: UIColor.white)
        title = "Filter"
        
        self.callGetCountryList { (data) in
            self.countryData = data
            
            if let filter = self.applyFilterData {
                if let first = self.countryData.filter({"\($0.Id)" == filter.pickupId}).first {
                    self.txtPickup.text = "\(first.CountryCode) \(first.Name)"
                }
                if let first = self.countryData.filter({"\($0.Id)" == filter.dropId}).first {
                    self.txtDropup.text = "\(first.CountryCode) \(first.Name)"
                }
                if let first = DashboardVC.truckTypeArray.filter({"\($0.Id)" == filter.serviceTypeId}).first {
                    self.txtTruckService.text = first.Name
                }
                self.txtPickupDate.text = filter.pickupDate
                self.txtStartDate.text = filter.startDate
                self.txtEndDate.text = filter.endDate
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectPickupAddress(_ sender: UIButton) {
        openCountryDropDown(anchorView: sender, data: countryData) { (str, index) in
            self.txtPickup.text = str
        }
    }
    
    @IBAction func selectDropOfAddress(_ sender: UIButton) {
        openCountryDropDown(anchorView: sender, data: countryData) { (str, index) in
            self.txtDropup.text = str
        }
    }
    
    @IBAction func selectTruckServiceAddress(_ sender: UIButton) {
        let arr = DashboardVC.truckTypeArray.compactMap({$0.Name})
        openDropDown(anchorView: sender, data: arr) { (str, index) in
            self.txtTruckService.text = DashboardVC.truckTypeArray[index].Name
        }
    }
    
    @IBAction func selectPickupDate(_ sender: UIButton) {
        openDatePicker(formate: "yyyy-MM-dd") { (str) in
            self.txtPickupDate.text = str
        }
    }
    
    @IBAction func selectStartDate(_ sender: UIButton) {
        openDatePicker(formate: "yyyy-MM-dd") { (str) in
            self.txtStartDate.text = str
        }
    }
    
    @IBAction func selectEndDate(_ sender: UIButton) {
        openDatePicker(formate: "yyyy-MM-dd") { (str) in
            self.txtEndDate.text = str
        }
    }
    
    @IBAction func btnFilterApplyCLK(_ sender: UIButton) {
        var filterData = FilterData()
        if let first = countryData.filter({"\($0.CountryCode) \($0.Name)" == txtPickup.text!}).first {
            filterData.pickupId = "\(first.Id)"
        }
        if let first = countryData.filter({"\($0.CountryCode) \($0.Name)" == txtDropup.text!}).first {
            filterData.dropId = "\(first.Id)"
        }
        if let first = DashboardVC.truckTypeArray.filter({$0.Name == txtTruckService.text!}).first {
            filterData.serviceTypeId = "\(first.Id)"
        }
        
        filterData.pickupDate = txtPickupDate.text!
        filterData.startDate = txtStartDate.text!
        filterData.endDate = txtEndDate.text!
        filterData.IsJobWithIssues = switchIssue.isOn ? "true" : ""
        if completionBlock != nil {
            completionBlock!(filterData)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFilterResetCLK(_ sender: UIButton) {
        if completionBlock != nil {
            completionBlock!(nil)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

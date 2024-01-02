//
//  TruckFualChartDataVC.swift
//  CargoXpress
//
//  Created by Alpesh Desai on 11/12/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import Charts

class TruckFualChartDataVC: UIViewController {

    @IBOutlet weak var txtStartDate: LetsFloatField!
    @IBOutlet weak var txtEndDate: LetsFloatField!
    
    var truckData = TruckData()
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChartView.isHidden = true
        
        if let dateS = Date().toString("yyyy-MM-dd") {
            self.txtStartDate.text = dateS
            self.txtEndDate.text = dateS
            self.btnGetFualDataCLK(UIButton())
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //showAlert("Enter start date & end date before tap on search")
    }
    
    @IBAction func btnGetFualDataCLK(_ sender: UIButton) {
        if txtStartDate.text!.isEmpty || txtEndDate.text!.isEmpty {
            showAlert("Please select both start & end date")
            return
        }
        if let dateS = txtStartDate.text!.toDate("yyyy-MM-dd"), let dateE = txtEndDate.text!.toDate("yyyy-MM-dd"), dateS > dateE {
            showAlert("Start date is not greater than End date")
        }
        
        let url = baseURL + URLS.TruckLocationFuel_All.rawValue + "?TruckId=\(truckData.Id)&FromDate=\(txtStartDate.text!)&ToDate=\(txtEndDate.text!)"
        callGetFualDataAPI(url: url) { (data) in
            if !data.isEmpty {
                self.lineChartView.isHidden = false
                self.setChartData(datas: data)
            } else {
                self.lineChartView.isHidden = true
                showAlert("No data available")
            }
        }
        
    }
    
    @IBAction func btnStartDateCLK(_ sender: UIButton) {
        openDatePicker(formate: "yyyy-MM-dd", mode: .date) { (str) in
            self.txtStartDate.text = str
        }
    }
    
    @IBAction func btnEndDateCLK(_ sender: UIButton) {
        openDatePicker(formate: "yyyy-MM-dd", mode: .date) { (str) in
            self.txtEndDate.text = str
        }
    }
    

}

extension TruckFualChartDataVC : ChartViewDelegate {

    
    func lineChartViewProperty()
    {
        lineChartView.clear()
        lineChartView.clearValues()
        lineChartView.data = nil
        lineChartView.noDataText = "No Stock Data Available For Now."
        lineChartView.delegate = self;
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.avoidFirstLastClippingEnabled = false
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = true
        lineChartView.doubleTapToZoomEnabled = true
        lineChartView.legend.enabled = false
        lineChartView.gridBackgroundColor = UIColor.black
        lineChartView.backgroundColor = UIColor.clear
        lineChartView.chartDescription!.text = ""
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelRotationAngle = -75
        lineChartView.xAxis.labelTextColor = UIColor.black
        lineChartView.legend.enabled = false
        
        lineChartView.leftAxis.labelTextColor = UIColor.black
        //lineChartView.leftAxis.axisMinimum = 0.0

        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: ChartEasingOption.easeInOutBounce)
        
        
        let xyMarker =  XYMarkerView(color: UIColor.blueColor(alpha: 0.8), font: UIFont(name: "HelveticaNeue-Light", size: 12.0)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 5.0, left: 8.0, bottom: 15.0, right: 8.0), xAxisValueFormatter: lineChartView.xAxis.valueFormatter!)
        xyMarker.minimumSize = CGSize(width: 60.0, height: 20.0)
        xyMarker.chartView = lineChartView
        lineChartView.marker = xyMarker
    }
    
    
    func setLineChartData(values : [ChartDataEntry] ,color : UIColor) -> LineChartDataSet {
        let set = LineChartDataSet(entries: values, label: "")
        set.drawIconsEnabled = false
        
        set.setColor(color)
        set.setCircleColor(color)
        set.lineWidth = 1
        set.circleRadius = 3
        set.drawCircleHoleEnabled = false
        set.drawValuesEnabled = true
        set.drawFilledEnabled = true
        set.fillAlpha = 0.7
        set.highlightLineWidth = 0.0
        return set
    }
    
    func setChartData(datas : [TruckFualData]) {
        lineChartViewProperty()
        var dataEntries: [ChartDataEntry] = []
        var dataEntries1: [ChartDataEntry] = []
        var dateArray = [String]()
        
        for (index,obj) in datas.enumerated() {
            print(obj.Fuel)
            dataEntries.append(ChartDataEntry(x: Double(Int(index)), y:obj.Fuel.ns.doubleValue , icon:nil, data:"\(String(format: "%@",obj.Fuel)) Fuel"))
            if index > 2 {
                let totalV = obj.Fuel.ns.doubleValue + datas[index-1].Fuel.ns.doubleValue + datas[index-2].Fuel.ns.doubleValue
                dataEntries1.append(ChartDataEntry(x: Double(Int(index)), y:totalV/3.0 , icon:nil, data:"\(String(format: "%@",obj.Fuel)) Avg. Fuel"))
            } else {
                dataEntries1.append(ChartDataEntry(x: Double(Int(index)), y:obj.Fuel.ns.doubleValue , icon:nil, data:"\(String(format: "%@",obj.Fuel)) Avg. Fuel"))
            }
            
            if let date = obj.CapturedDate.toDate("dd-MM-yyyy HH:mm:ss"), let str = date.toString("dd-MMM-yy hh:mm a") {
                dateArray.append(str)
            }
        }
        
        let lineChartDataSet = setLineChartData(values: dataEntries, color: UIColor.blueColor())
        lineChartDataSet.fill = Fill.init(CGColor: UIColor.blueColor(alpha: 0.3).cgColor)
        
        let lineChartDataSet1 = setLineChartData(values: dataEntries1, color: UIColor.systemGreen)
        lineChartDataSet1.fill = Fill.init(CGColor: UIColor.clear.cgColor)
        
        //, lineChartDataSet //lineChartDataSet1
        let chartDataArr = LineChartData(dataSets: [lineChartDataSet])
        lineChartView.data = chartDataArr
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateArray)
        lineChartView.moveViewToX(Double(dateArray.count-1))
        //lineChartView.setVisibleXRangeMinimum(10.0)
        //lineChartView.setVisibleXRangeMaximum(10.0)
        
        DispatchQueue.main.async {
            self.lineChartView.notifyDataSetChanged()
        }
    }
}

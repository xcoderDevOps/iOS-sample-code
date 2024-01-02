//
//  TruckStandAloneLocationVC.swift
//  CargoXpress
//
//  Created by Alpesh Desai on 11/12/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import MapKit

class TruckStandAloneLocationVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var txtStartDate: LetsFloatField!
    @IBOutlet weak var txtEndDate: LetsFloatField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var truckData = TruckData()
    var isStandAlone = "true"
    var jobId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        if let dateS = Date().toString("yyyy-MM-dd") {
            self.txtStartDate.text = dateS
            self.txtEndDate.text = dateS
            self.btnGetFualLocationCLK(UIButton())
        }
        // Do any additional setup after loading the view.
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
    
    @IBAction func btnGetFualLocationCLK(_ sender: UIButton) {
        if txtStartDate.text!.isEmpty || txtEndDate.text!.isEmpty {
            showAlert("Please select both start & end date")
            return
        }
        if let dateS = txtStartDate.text!.toDate("yyyy-MM-dd"), let dateE = txtEndDate.text!.toDate("yyyy-MM-dd"), dateS > dateE {
            showAlert("Start date is not greater than End date")
        }
        
        let url = baseURL + URLS.TruckLocation_All.rawValue + "?TruckId=\(truckData.Id)&FromDate=\(txtStartDate.text!)&ToDate=\(txtEndDate.text!)&JobNUllData=\(isStandAlone)" + "\(jobId.isEmpty ? "": "&JobId=\(jobId)")"
        callGetLocationDataAPI(url: url) { (data) in
            if !data.isEmpty {
                self.mapView.removeAnnotations(self.mapView.annotations)
                var ans = [MyPointAnnotation]()
                for (index,loc) in data.enumerated() {
                    let lat = loc.Lat.ns.doubleValue
                    let long = loc.Long.ns.doubleValue
                    let loct = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let pin = MyPointAnnotation()
                    pin.accessibilityValue = "\(index)"
                    pin.coordinate = loct
                    if let d = data.first, d.Lat == loc.Lat, d.Long == loc.Long {
                        print("First")
                        pin.pinTintColor = UIColor.yellow
                    } else if let d = data.last, d.Lat == loc.Lat, d.Long == loc.Long  {
                        print("Last")
                        pin.pinTintColor = UIColor.red
                    } else {
                        pin.pinTintColor = UIColor.green
                    }
                    ans.append(pin)
                }
                self.mapView.addAnnotations(ans)
                DispatchQueue.main.async {
                    self.mapView.fitAllAnnotations()
                }
            } else {
                showAlert("No data available")
            }
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myAnnotation") as? MKPinAnnotationView

            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myAnnotation")
            } else {
                annotationView?.annotation = annotation
            }

            if let annotation = annotation as? MyPointAnnotation {
                annotationView?.pinTintColor = annotation.pinTintColor
                annotationView?.tintColor = annotation.pinTintColor
            } else {
                print("wrong")
            }

            return annotationView
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


class MyPointAnnotation : MKPointAnnotation {
    var pinTintColor: UIColor?
}

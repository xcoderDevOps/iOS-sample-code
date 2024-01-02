//
//  TruckAllMapScreenVC.swift
//  CargoXpress
//
//  Created by Alpesh Desai on 04/01/21.
//  Copyright © 2021 Rushkar. All rights reserved.
//

import UIKit
import MapKit

class TruckAllMapScreenVC: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    var mapAnnotations = [CustomPointAnnotation]()
    var truckArray = [TruckData]()
    var timer : Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAPI()
        setupData()
        DispatchQueue.main.async {
            self.mapView.fitAllAnnotations()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(callAPI), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
    }
    
    @objc func callAPI() {
        callGetTruckList { (data) in
            self.truckArray = data
            self.setupData()
        }
    }

    func setupData() {
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapAnnotations.removeAll()
        for obj in truckArray {
            if !obj.Latitude.isEmpty && !obj.Longitude.isEmpty {
                let info = CustomPointAnnotation()
                info.coordinate = CLLocationCoordinate2DMake(obj.Latitude.ns.doubleValue, obj.Longitude.ns.doubleValue)
                var moving = ""
                if obj.IsMoving == 1 {
                    moving = "Moving"
                    info.imageName = "ic_truck_green"
                } else if obj.IsMoving == 2 {
                    moving = "Stable"
                    info.imageName = "ic_truck_red"
                } else {
                    moving = "New"
                    info.imageName = "ic_truck_yello"
                }
                info.title =  "\(obj.PlateNumber) (\(moving))"
                info.subtitle = "Speed:\(obj.Speed) | Fuel Level:\(obj.FuelLevel)"
                self.mapAnnotations.append(info)
                self.mapView.addAnnotations(self.mapAnnotations)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            let cpa = annotation as! CustomPointAnnotation
            anView!.image = UIImage(named:cpa.imageName)
            anView!.canShowCallout = true
            
        }
        else {
            let cpa = annotation as! CustomPointAnnotation
            anView!.image = UIImage(named:cpa.imageName)
            anView!.annotation = annotation
            anView!.canShowCallout = true
        }
        return anView
        
    }
    
    //MARK: mapview AnotationEvent
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }

}

//
//  JobDriverLocationMapVC.swift
//  CargoXpress
//
//  Created by infolabh on 23/08/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import MapKit

class JobDriverLocationMapVC: UIViewController, MKMapViewDelegate {
    var jobData = JobData()
    var driverId = 0
    
    @IBOutlet weak var mapView: MKMapView!
    var mapAnnotations : [CustomPointAnnotation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Job No: \(jobData.JobNo)"
        backButton(color: UIColor.white)
        mapAnnotations = [CustomPointAnnotation]()
        self.getDriverLocation()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnRefreshJobClk(_ sender: UIButton) {
        getDriverLocation()
    }
    
    func getDriverLocation() {
        self.callGetJobLocationData(jobId: "\(jobData.Id)", driverId: "\(driverId)") { (data) in
            
            self.removeAllPlacemarkFromMap(shouldRemoveUserLocation: true)
            
            self.addMapAnotationPin(self.jobData.PickUpAddressLatitude.ns.doubleValue, long: self.jobData.PickUpAddressLongitude.ns.doubleValue, address: self.jobData.PickUpAddress, isStartAddress: true)
            self.addMapAnotationPin(self.jobData.DropOffAddressLatitude.ns.doubleValue, long: self.jobData.DropOffAddressLongitude.ns.doubleValue, address: self.jobData.DropOffAddress, isStartAddress: false)
            
            var ans = [MKAnnotation]()
            for loc in data {
                let lat = loc.Latitude.ns.doubleValue
                let long = loc.Longitude.ns.doubleValue
                let loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let pin = MKPointAnnotation()
                pin.coordinate = loc
                ans.append(pin)
            }
            self.mapView.addAnnotations(ans)
        }
    }
    
    func removeAllPlacemarkFromMap(shouldRemoveUserLocation:Bool){
        if let mapView = self.mapView {
            for annotation in mapView.annotations{
                if shouldRemoveUserLocation {
                    if annotation as? MKUserLocation !=  mapView.userLocation {
                        mapView.removeAnnotation(annotation as MKAnnotation)
                    }
                }
            }
        }
    }
    
    
    func addMapAnotationPin(_ lat : Double,long : Double, address :String,isStartAddress : Bool)
    {
        let info = CustomPointAnnotation()
        info.coordinate = CLLocationCoordinate2DMake(lat, long)
        let array = seperateAddressFromString(address)
        
        info.title = array.0
        info.subtitle = array.1
        info.imageName = "location"
        
        if self.mapAnnotations?.count == 2
        {
            if isStartAddress
            {
                self.mapAnnotations?.removeFirst()
            }
            else
            {
                self.mapAnnotations?.removeLast()
            }
        }
        
        self.mapAnnotations?.append(info)
        
        DispatchQueue.main.async {
            
            print(self.mapAnnotations)
            
            self.mapView.addAnnotations(self.mapAnnotations!)
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
            anView!.annotation = annotation
        }
        return anView
        
    }
    
    //MARK: mapview AnotationEvent
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }

}

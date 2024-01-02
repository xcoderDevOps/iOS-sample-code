//
//  AvailableJobListVC.swift
//  CargoXpress
//
//  Created by infolabh on 08/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import MapKit

class AvailableJobDetailsVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var btnDecline: UIButton!
    @IBOutlet weak var btnBidBid: UIButton!
    
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var lblTruckType: UILabel!
    @IBOutlet weak var JobInfo: UILabel!
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var extraInfo: UILabel!
    
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblJobNo: UILabel!
    
    @IBOutlet weak var bidView: UIView!
    @IBOutlet weak var lblBidAmount: UILabel!
    
    @IBOutlet weak var lblJobCreateDate: UILabel!
    
    var jobData = JobData()
    var isFromBidList = false
    
    var locationManager: CLLocationManager!
    var mapManager = MapManager()
    var mapAnnotations : [CustomPointAnnotation]?
    var bidId = 0
    
    var jobBidData : JobBidData?
    var rightBar : UIBarButtonItem!
    
    @objc func shareJobPath() {
        if let link = URL(string: "http://admin.auroratechafrica.com/PublicJobs/Index?Id=\(jobData.Id)")
        {
            let activityVC = UIActivityViewController(activityItems: [link], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromBidList {
            title = "Job Detail"
            backButton(color: UIColor.white)
            btnDecline.setTitle("CANCEL", for: UIControl.State.normal)
        } else {
            title = "Available Job"
            backButton(color: UIColor.white)
        }
        
        rightBar = UIBarButtonItem(image: UIImage(named: "ic_share"), style: UIBarButtonItem.Style.done, target: self, action: #selector(shareJobPath))
        self.navigationItem.setRightBarButton(rightBar, animated: true)
        lblJobNo.text = "Job No: \(jobData.JobNo)"
        lblServiceType.text = "Service Type: \(jobData.TruckService)"
        lblTruckType.text = jobData.TruckType
        lblJobCreateDate.text = "Job Created On: \(jobData.CreatedDateStr)"
        
        var arrayData = [String]()
        
        if jobData.TotalPallets > 0 {
            arrayData.append("Total Pallets: \(jobData.TotalPallets)")
        }
        if jobData.Cbm > 0 {
            arrayData.append("CBM: \(jobData.TotalPallets)")
        }
        
        if !jobData.HsCode.isEmpty {
            arrayData.append("CBM: \(jobData.HsCode)")
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
        if !jobData.Kg.isEmpty && jobData.Kg != "0" {
            arrayData.append("Kg: \(jobData.Kg)")
        }
        if !jobData.DeliveryItem.isEmpty {
            arrayData.append("DeliveryItem: \(jobData.DeliveryItem)")
        }
        
        
        lblDate.text = "--"
        if let dateStr = jobData.PickupDate.components(separatedBy: " ").first {
            lblDate.text = "\(dateStr)"
        }
        
        lblDistance.text = "--"
        if jobData.Distance > 0.0 {
            lblDistance.text = String(format: "%.2f Km", jobData.Distance)
        }
        
        if jobData.SpecialMessage.isEmpty {
            infoTitle.isHidden = true
            extraInfo.isHidden = true
        } else {
            infoTitle.isHidden = false
            extraInfo.isHidden = false
            extraInfo.text = jobData.SpecialMessage
        }
        
        JobInfo.text = arrayData.joined(separator: "\n")
        lblPickUp.text = jobData.PickUpAddress
        lblDropOff.text = jobData.DropOffAddress
        
        mapAnnotations = [CustomPointAnnotation]()
        mapView.showsUserLocation = true
        
        mapAnnotations = [CustomPointAnnotation]()
        addMapAnotationPin(jobData.PickUpAddressLatitude.ns.doubleValue, long: jobData.PickUpAddressLongitude.ns.doubleValue, address: jobData.PickUpAddress, isStartAddress: true)
        addMapAnotationPin(jobData.DropOffAddressLatitude.ns.doubleValue, long: jobData.DropOffAddressLongitude.ns.doubleValue, address: jobData.DropOffAddress, isStartAddress: false)
        DispatchQueue.main.async {
            self.mapView.fitAllAnnotations()
        }
        
//        getDirectionsUsingApple(startLat: jobData.PickUpAddressLatitude.ns.doubleValue, startLong: jobData.PickUpAddressLongitude.ns.doubleValue, endLat: jobData.DropOffAddressLatitude.ns.doubleValue, endLong: jobData.DropOffAddressLongitude.ns.doubleValue)
        
        bidView.isHidden = true
        callBidData()
        // Do any additional setup after loading the view.
    }
    
    func callBidData() {
        callGetBidList(url: baseURL+URLS.JobBids_ByJobId.rawValue+"CarrierId=\(UserInfo.savedUser()!.Id)&JobId=\(jobData.Id)") { (data) in
            if let bid = data.first {
                self.jobBidData = bid
                self.bidView.isHidden = false
                self.lblBidAmount.text = String(format: "$%.2f", bid.Price)
                self.btnBidBid.setTitle("Change Bid", for: UIControl.State.normal)
                self.bidId = bid.Id
            }
        }
    }
    
    @IBAction func tapOnBidCLK(_ sender: UIButton) {
        if let bid = jobBidData {
            _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupChangeBidVC", blockOK: { (obj) in
                dismissPopUp()
                self.callBidData()
            }, blockCancel: {
                dismissPopUp()
            }, objData: bid as AnyObject)
        } else {
            _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupChangeBidVC", blockOK: { (obj) in
                dismissPopUp()
                self.callBidData()
            }, blockCancel: {
                dismissPopUp()
            }, objData: jobData as AnyObject)
        }
        
    }
    
    
    @IBAction func tapOnDeclineBidCLK(_ sender: UIButton) {
        if isFromBidList {
            alertShow(self, title: "", message: "Are you sure want to cancel your bid", okStr: "Yes", cancelStr: "No", okClick: {
                self.navigationController?.popViewController(animated: true)
            }, cancelClick: nil)
        }
    }
}

extension AvailableJobDetailsVC : CLLocationManagerDelegate, MKMapViewDelegate
{
    //MARK:- MapView Method for create path -
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 3
            print("done")
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    func drawPathBetweenToPlace(){
        
        //self.view.endEditing(true)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        if (locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization))) {
            //locationManager.requestAlwaysAuthorization() // add in plist NSLocationAlwaysUsageDescription
            locationManager.requestAlwaysAuthorization() // add in plist NSLocationWhenInUseUsageDescription
        }
    }
    
    func getDirectionsUsingApple(startLat: Double,startLong: Double, endLat: Double, endLong: Double) {
        
        
        //TODO:Change
        mapManager.directionsUsingGoogle(from: CLLocationCoordinate2DMake(startLat, startLong), to: CLLocationCoordinate2DMake(endLat, endLong)) { (route, directionInformation, boundingRegion, error) in
            if (error != nil) {
                print(error!)
            }
            else {

                if let web = self.mapView {
                    DispatchQueue.main.async {

                        self.removeAllPlacemarkFromMap(shouldRemoveUserLocation: true)
                        self.mapView.clearsContextBeforeDrawing = true
                        self.mapView.removeOverlays(self.mapView.overlays)

                        //self.removewPolyline()

                        web.addOverlay(route!)
                        web.setVisibleMapRect(boundingRegion!, animated: true)

                        let sLat = (directionInformation!["start_location"] as! [String : Any])["lat"] as? Double
                        let sLng = (directionInformation!["start_location"] as! [String : Any])["lng"] as? Double

                        distanceDateTime.distance = (directionInformation!["distance"] as? String)!

                        self.addMapAnotationPin(sLat!, long: sLng!,address: self.jobData.PickUpAddress, isStartAddress: true)

                        let eLat = (directionInformation!["end_location"] as! [String : Any])["lat"] as? Double
                        let eLng = (directionInformation!["end_location"] as! [String : Any])["lng"] as? Double
                        self.addMapAnotationPin(eLat!, long: eLng!,address: self.jobData.DropOffAddress,isStartAddress: false)
                    }
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        var hasAuthorised = false
        var locationStatus:NSString = ""
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access"
        case CLAuthorizationStatus.denied:
            locationStatus = "Denied access"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Not determined"
        default:
            locationStatus = "Allowed access"
            hasAuthorised = true
        }
        
        if(hasAuthorised == true) {
            //getDirectionsUsingApple()
        }
        else {
            print("locationStatus \(locationStatus)")
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
    
    
    //MARK: locationDelegate
    
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
            if let anotations = self.mapAnnotations {
                self.mapView.addAnnotations(anotations)
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
            anView!.annotation = annotation
        }
        return anView
        
    }
    
    //MARK: mapview AnotationEvent
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
    
}

//
//  ReturnSelectAddressVC.swift
//  CargoXpress
//
//  Created by infolabh on 24/08/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SVProgressHUD
import GooglePlaces

class ReturnSelectAddressVC: UIViewController {

    //MARK: - Variable declaration -
    var completionBlock : (()->())?
    
    @IBOutlet weak var lblStartAdd: UILabel!
    @IBOutlet weak var lblEndAdd: UILabel!
    @IBOutlet weak var txtStartAddress: UITextView!
    @IBOutlet weak var txtEndAddress: UITextView!
    
    
    @IBOutlet weak var imgStart: UIImageView!
    @IBOutlet weak var imgEnd: UIImageView!
    
    @IBOutlet weak var viewStart: LetsView!
    @IBOutlet weak var viewEnd: LetsView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var mapManager = MapManager()
    var locationManager: CLLocationManager!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topViewConstrain: NSLayoutConstraint! // 158 73
    @IBOutlet weak var viewAddressList: UIView!

    struct AddressList {
        var name = ""
        var id = ""
    }
    var arrayAddressList = [AddressList]()
    var searchQuery = SPGooglePlacesAutocompleteQuery()
    
    var selectedDate = ""
    var selectedTime = ""

    var isStartAddress = Bool()
    
    var mapAnnotations : [CustomPointAnnotation]?
    private var placesClient: GMSPlacesClient!

   //MARK: - View life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        backButton(color: UIColor.white)
        
        startAddress = AddressDetail()
        endAddress = AddressDetail()
        
        title = "Select address"
        mapAnnotations = [CustomPointAnnotation]()
        mapView.showsUserLocation = true
        viewAddressList.isHidden = true
    
        
        searchQuery = SPGooglePlacesAutocompleteQuery(apiKey: GooglePlaceKey)
        //searchQuery.countryCode = "CA"
        
//        if appDelegate.lat != ""
//        {
//            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(NSString(format: "%@", appDelegate.lat).doubleValue,NSString(format: "%@", appDelegate.long).doubleValue)
//            searchQuery.location = location
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver("doZoom")
    }
    
    func zoomLevelForCurrentLocation()
    {
        var span: MKCoordinateSpan = MKCoordinateSpan()
        span.latitudeDelta = 1/300
        span.longitudeDelta = 1/300
        var coordinateRegion = MKCoordinateRegion()
        coordinateRegion.span = span
        //coordinateRegion.center = CLLocationCoordinate2DMake(NSString(format: "%@", appDelegate.lat).doubleValue, NSString(format: "%@", appDelegate.long).doubleValue)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /**
     Button Continue Clicked
     
     - important: Continue click for next screen
     - returns: false
     - parameter sender: after click on time button
     - - -
     [Bindle Inc.](https://www.getbindle.com/)
     - - -
     */
    
    @IBAction func btnContinueClicked(_ sender: UIButton) {
        
        
        if txtStartAddress.text?.trim == "" || txtEndAddress.text?.trim == ""
        {
            showAlert(popUpMessage.emptyString.rawValue)
            return
        }
        else if txtStartAddress.text! == txtEndAddress.text!
        {
            showAlert("Pickup and Drop address both are same")
            return
        }
        else if  distanceDateTime.distance == ""
        {
            showAlert(popUpMessage.someWrong.rawValue)
            return
        } else {
            if self.completionBlock != nil {
                self.completionBlock!()
            }
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
    
    func setStartEndAddress(_ data : AddressList , isStart : Bool)
    {
        viewAddressList.isHidden = true
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue))!
        
        if isStart
        {
            txtStartAddress.text = data.name
            lblStartAdd.isHidden = !data.name.trim.isEmpty
            startAddress.address = txtStartAddress.text!
        }
        else
        {
            txtEndAddress.text = data.name
            endAddress.address = txtEndAddress.text!
            lblEndAdd.isHidden = !data.name.trim.isEmpty
        }
        
        placesClient?.fetchPlace(fromPlaceID: data.id, placeFields: fields, sessionToken: nil, callback: {
          (place1: GMSPlace?, error: Error?) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            return
          }
            
          if let place1 = place1 {
            if isStart {
                startAddress.lat = "\(place1.coordinate.latitude)"
                startAddress.long = "\(place1.coordinate.longitude)"
            } else {
                endAddress.lat = "\(place1.coordinate.latitude)"
                endAddress.long = "\(place1.coordinate.longitude)"
            }
            self.addMapAnotationPin(place1.coordinate.latitude, long: place1.coordinate.longitude,address: data.name)
            
            if self.txtStartAddress.text != self.txtEndAddress.text && self.txtStartAddress.text != "" && self.txtEndAddress.text != ""
            {
                let sLoc = CLLocation(latitude: startAddress.lat.ns.doubleValue, longitude: startAddress.long.ns.doubleValue)
                let eLoc = CLLocation(latitude: endAddress.lat.ns.doubleValue, longitude: endAddress.long.ns.doubleValue)
                let distance = sLoc.distance(from: eLoc)
                distanceDateTime.distance = String(format: "%.3f km",distance/1000)
                //self.getDirectionsUsingApple()
                //drawPathBetweenToPlace()
                DispatchQueue.main.async {
                    self.mapView.fitAllAnnotations()
                }
            }
          }
        })
    }
    
    @IBAction func btnCloseKeybord(_ sender: UIButton) {
        
        
        if isStartAddress {
            if txtStartAddress.text.trim == "" {
                self.view.endEditing(true)
                viewAddressList.isHidden = true
                lblStartAdd.isHidden = false
            }
        }
        else {
            
            if txtEndAddress.text.trim == "" {
                self.view.endEditing(true)
                viewAddressList.isHidden = true
                lblEndAdd.isHidden = false
            }
        }
    }
    

}

extension ReturnSelectAddressVC : UITableViewDelegate, UITableViewDataSource
{
    //MARK: TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAddressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell") as! AddressListCell
        cell.lblAddress.text = arrayAddressList[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewAddressList.isHidden = true
        
        let address = arrayAddressList[indexPath.row]
        self.setStartEndAddress(address, isStart: self.isStartAddress)
        
        arrayAddressList = []
        tableView.reloadData()
        
        self.view.endEditing(true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:Draw Line Bteween Two Location

extension ReturnSelectAddressVC : CLLocationManagerDelegate, MKMapViewDelegate
{
    
    
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
     
        self.view.endEditing(true)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        if (locationManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))) {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func clearMap() {
        self.removeAllPlacemarkFromMap(shouldRemoveUserLocation: true)
        self.mapView.clearsContextBeforeDrawing = true
        self.mapView.removeOverlays(self.mapView.overlays)
    }
    
    func getDirectionsUsingApple() {
        //TODO: Change
        
        mapManager.directionsUsingGoogle(from: txtStartAddress.text!.ns, to: txtEndAddress.text!.ns) { (route, directionInformation, boundingRegion, error) in
            if let error = error {
                showAlert(error)
            }
            else {

                if let web = self.mapView {
                    DispatchQueue.main.async {

                        self.clearMap()
                        //self.removewPolyline()

                        web.addOverlay(route!)
                        web.setVisibleMapRect(boundingRegion!, animated: true)

                        let sLat = (directionInformation!["start_location"] as! [String : Any])["lat"] as? Double
                        let sLng = (directionInformation!["start_location"] as! [String : Any])["lng"] as? Double

                        let geocoder: CLGeocoder = CLGeocoder()
                        geocoder.reverseGeocodeLocation(CLLocation(latitude: sLat!, longitude: sLng!), completionHandler: { (placemarks, error) in
                            if placemarks != nil
                            {
                                let result  : CLPlacemark = placemarks![0]
                                let placemark: MKPlacemark = MKPlacemark(placemark: result)
                                let administrativeArea = (placemark.administrativeArea != nil) ? placemark.administrativeArea : ""
                                distanceDateTime.administrativeArea = administrativeArea!
                                print(administrativeArea)
                            }
                        })
                        
                        print(directionInformation)
                        if let distance = directionInformation!["distance"] as? String
                        {
                            if distance.range(of: "km") != nil
                            {
                                distanceDateTime.distance = (directionInformation!["distance"] as? String)!
                            }
                            else if distance.range(of: " m") != nil
                            {
                                let dis = distance.replacingOccurrences(of: "m", with: "")
                                let x = NSString(format: "%@",dis.trim).doubleValue

                                distanceDateTime.distance = String(format: "%.3f km",x/1000)
                            }


                            startAddress.lat = String(format: "%f",sLat!)
                            startAddress.long = String(format: "%f",sLng!)

                            self.addMapAnotationPin(sLat!, long: sLng!,address: self.txtStartAddress.text!)

                            let eLat = (directionInformation!["end_location"] as! [String : Any])["lat"] as? Double
                            let eLng = (directionInformation!["end_location"] as! [String : Any])["lng"] as? Double

                            endAddress.lat = String(format: "%f",eLat!)
                            endAddress.long = String(format: "%f",eLng!)

                            self.addMapAnotationPin(eLat!, long: eLng!,address: self.txtEndAddress.text!)

                        }
                        else {
                            if self.isStartAddress {
                                startAddress.address = ""
                                self.txtStartAddress.text = ""
                                self.lblStartAdd.isHidden = false
                                showAlert("Please enter valid address")
                            }
                            else {
                                endAddress.address = ""
                                self.txtEndAddress.text = ""
                                self.lblEndAdd.isHidden = false
                                showAlert("Please enter valid address")
                            }
                        }

                        print(directionInformation)
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
            getDirectionsUsingApple()
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
    
    func addMapAnotationPin(_ lat : Double,long : Double, address :String)
    {
        let info = CustomPointAnnotation()
        info.coordinate = CLLocationCoordinate2DMake(lat, long)
        let array = seperateAddressFromString(address)
        print(address)
        info.title = array.0
        info.subtitle = array.1
        info.imageName = "location"
        
        if self.mapAnnotations?.count == 2
        {
            if self.isStartAddress
            {
                self.mapAnnotations?.removeFirst()
            }
            else
            {
                self.mapAnnotations?.removeLast()
            }
        }
        
        self.mapAnnotations?.append(info)
        self.mapView.addAnnotations(self.mapAnnotations!)
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

//MARK : Address List From Google API

extension ReturnSelectAddressVC : UITextViewDelegate
{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    
        if textView == txtStartAddress
        {
            isStartAddress = true
            topViewConstrain.constant = 95.0
            imgStart.image = UIImage(named: "ic_blue_navigate")
            viewStart.borderColor = UIColor.blueColor()
            lblStartAdd.isHidden = true
        }
        else
        {
            isStartAddress = false
            topViewConstrain.constant = 178.0
            imgEnd.image = UIImage(named: "ic_blue_navigate")
            viewEnd.borderColor = UIColor.blueColor()
            lblEndAdd.isHidden = true
        }
        
        if textView.text != ""
        {
            handleSearchForSearchString(textView.text!)
        }
        
        self.view.layoutIfNeeded()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtStartAddress
        {
            imgStart.image = UIImage(named: "ic_navigate")
            viewStart.borderColor = UIColor.lightGray
            if textView.text == ""
            {
                lblStartAdd.isHidden = false
            }
        }
        else
        {
            imgEnd.image = UIImage(named: "ic_navigate")
            viewEnd.borderColor = UIColor.lightGray
            if txtEndAddress.text == ""
            {
                lblEndAdd.isHidden = false
            }
        }
       // viewAddressList.hidden = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.textInputMode?.primaryLanguage == nil //|| text.length > 1
        {
            return false
        }
        
        if textView == txtStartAddress
        {
            isStartAddress = true
            lblStartAdd.isHidden = true
        }
        else {
            isStartAddress = false
            lblEndAdd.isHidden = true
        }
        
        if textView.text.trim != "" || text != ""
        {
            viewAddressList.isHidden = false
        }
        else
        {
            viewAddressList.isHidden = true
        }
        handleSearchForSearchString(textView.text!+text)
        return true
    }
    
    func handleSearchForSearchString(_ searchString : String)
    {
        var uniqueArray = NSArray()
        
        searchQuery.input = searchString
        
        
        searchQuery.fetchPlaces { (places, error) -> Void in
            if ((error) != nil)
            {
                print(error)
            }
            else
            {
                self.arrayAddressList = []
                uniqueArray = places as! NSArray
                
                for obj in uniqueArray
                {
                    
                    self.arrayAddressList.append(AddressList(name: (obj as AnyObject).name as String, id: (obj as AnyObject).reference))
                }
                
                self.tableView.reloadData()
                
            }
        }
    }
}

//
//  ReturnContainerDetailVC.swift
//  CargoXpress
//
//  Created by infolabh on 24/08/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import MapKit
import PDFKit
import MobileCoreServices
import FloatRatingView

class ReturnContainerDetailVC: UIViewController {

    @IBOutlet weak var topMapView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var addressDetail: LetsView!
    @IBOutlet weak var addAddress: LetsView!
    
    
    var jobData = JobData()
    
    var locationManager: CLLocationManager!
    var mapManager = MapManager()
    var mapAnnotations : [CustomPointAnnotation]?
    
    @IBOutlet weak var btnJobAction: UIButton!
    
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!
    
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var tableDriverTruck: UITableView!
    
    @IBOutlet weak var viewAddDriverTruck: LetsView!
    @IBOutlet weak var viewDriverCarierTable: UIView!
    
    @IBOutlet weak var lblmainJobNo: UILabel!
    @IBOutlet weak var lblParentJobNo: UILabel!
    
    var truckDriverList = [TruckDriverComboData]() {
        didSet {
            self.viewDriverCarierTable.isHidden  = self.truckDriverList.isEmpty
            self.heightTableView.constant = CGFloat(Double(self.truckDriverList.count) * 165.0) + 16
        }
    }
    
    var locationArray = [CLLocation]()
    
    var anView1 : LetsAnnotationView?
    
    var status = 0
    
    var timer : Timer?
    
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
        title = "Job Detail"
        backButton(color: UIColor.white)
        setupinitData()
        viewDriverCarierTable.isHidden  = true
        viewAddDriverTruck.isHidden = true
        getJobFromAPI()
        
        rightBar = UIBarButtonItem(image: UIImage(named: "ic_share"), style: UIBarButtonItem.Style.done, target: self, action: #selector(shareJobPath))
        self.navigationItem.setRightBarButton(rightBar, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(getJobFromAPI), userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    func setupinitData() {
        
        lblmainJobNo.text =     "Job No:        \(jobData.JobNo)"
        lblParentJobNo.text =   "Parent Job No: \(jobData.ParentJobNo)"
        var arrayData = [String]()
        
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
        
        if jobData.PickUpAddress.isEmpty && jobData.DropOffAddress.isEmpty {
            topMapView.isHidden = true
            addressDetail.isHidden = true
            addAddress.isHidden = false
        } else {
            addAddress.isHidden = true
            topMapView.isHidden = false
            addressDetail.isHidden = false
            lblPickUp.text = jobData.PickUpAddress
            lblDropOff.text = jobData.DropOffAddress
        }
        
        mapAnnotations = [CustomPointAnnotation]()
        self.mapView.removeAnnotations(self.mapView.annotations)
        addMapAnotationPin(jobData.PickUpAddressLatitude.ns.doubleValue, long: jobData.PickUpAddressLongitude.ns.doubleValue, address: jobData.PickUpAddress, isStartAddress: true)
        addMapAnotationPin(jobData.DropOffAddressLatitude.ns.doubleValue, long: jobData.DropOffAddressLongitude.ns.doubleValue, address: jobData.DropOffAddress, isStartAddress: false)
        DispatchQueue.main.async {
            self.mapView.fitAllAnnotations()
        }
    }

    
    @IBAction func btnAddAddressLCLK(_ sender: LetsButton) {
        let controll = DriverBoard.instantiateViewController(identifier: "ReturnSelectAddressVC") as! ReturnSelectAddressVC
        controll.completionBlock = { () -> Void in
            
            self.jobData.PickUpAddress = startAddress.address
            self.jobData.DropOffAddress = endAddress.address
            
            self.jobData.PickUpAddressLatitude = startAddress.lat
            self.jobData.PickUpAddressLongitude = startAddress.long
            
            self.jobData.DropOffAddressLatitude = endAddress.lat
            self.jobData.DropOffAddressLongitude = endAddress.long
            
            let param = [
                        "Id":self.jobData.Id,
                        "PickUpAddress":startAddress.address,
                        "PickUpAddressLatitude":startAddress.lat,
                        "PickUpAddressLongitude":startAddress.long,
                        "DropOffAddress":endAddress.address,
                        "DropOffAddressLatitude":endAddress.lat,
                        "DropOffAddressLongitude":endAddress.long] as [String : AnyObject]
                self.setupinitData()
                self.callAddJob(url: baseURL+URLS.Job_Insert.rawValue, param) { (data) in
                if let data = data {
                    self.jobData = data
                    self.getJobFromAPI()
                }
            }
        }
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    
   @objc func getJobFromAPI() {
        callGetJobDataFromjobID(url: baseURL+URLS.Job_ById.rawValue+"\(jobData.Id)") { (data) in
            if let data = data {
                self.jobData = data
                self.setupinitData()
                self.updateJobStatus()
            }
        }
    }
    
    func updateJobStatus() {
        
        if jobData.PickUpAddress.isEmpty && jobData.DropOffAddress.isEmpty {
            topMapView.isHidden = true
            addressDetail.isHidden = true
        } else {
            topMapView.isHidden = false
            addressDetail.isHidden = false
            lblPickUp.text = jobData.PickUpAddress
            lblDropOff.text = jobData.DropOffAddress
        }
        
        if let status = JobStatus(rawValue : jobData.JobStatusId) {
            btnJobAction.isHidden = true
            
            if status == .NewJobReturn {
                btnJobAction.isHidden = false
                btnJobAction.setTitle("Start Job", for: UIControl.State.normal)
            } else if status == .OngoingJobReturn {
                btnJobAction.isHidden = false
                btnJobAction.setTitle("Complete Job", for: UIControl.State.normal)
            } else if status == .OngoingJobReturn {
                btnJobAction.isHidden = true
            }
        }
       
        viewAddDriverTruck.isHidden = false
        self.callGetDriverTruckList()
    }
    
    func callGetDriverTruckList() {
        self.callTruckDriverListAPI(job_id: "\(self.jobData.Id)") { (data) in
            self.truckDriverList = data
            self.tableDriverTruck.reloadData()
        }
    }
    
    var geodisc : MKGeodesicPolyline?
    func addPolylineToMap(locations: [CLLocation]) {
        if let geodisc = geodisc {
            mapView.removeOverlay(geodisc)
        }
        let coordinates = locations.map { $0.coordinate }
        geodisc = MKGeodesicPolyline(coordinates: coordinates, count: coordinates.count)
        if let geodisc = geodisc {
            mapView.addOverlay(geodisc)
        }
    }
    
    @IBAction func btnStartJob(_ sender: UIButton) {
        self.alertShow(self, title: "", message: "Are you sure you want to change the status?", okStr: "Yes", cancelStr: "No", okClick: {
            self.changeStatus()
        }, cancelClick: nil)
        
    }
    
    
    func changeStatus() {
        if let status = JobStatus(rawValue : jobData.JobStatusId) {
            if status == .NewJobReturn {
                self.jobStatusChage(status: jobData.JobStatusId+1)
            } else if status == .OngoingJobReturn {
                 self.jobStatusChage(status: jobData.JobStatusId+1)
            } else {
                self.jobStatusChage(status: jobData.JobStatusId+1)
            }
        }
    }
    
    func jobStatusChage(status : Int) {
        let url = baseURL+URLS.Job_JobStatus.rawValue
        let param = ["Id":jobData.Id, "JobStatusId":status]
        calChangeJobStatus(url: url, param) { (data) in
            if let data = data {
                self.jobData = data
                self.getJobFromAPI()
            }
        }
    }
    
    @IBAction func btnAddDriverTruckCLK(_ sender: UIButton) {
        let con1 = DriverBoard.instantiateViewController(identifier: "DriverListVC") as! DriverListVC
           con1.isFromWonAdd = true
           con1.blockAssignDrtiverAdd = { (driver) -> Void in
               let con2 = DriverBoard.instantiateViewController(identifier: "CarrierListVC") as! CarrierListVC
               con2.isFromWonAdd = true
               con2.blockAssignCareerAdd = { (truck) -> Void in
                let param = ["JobId": self.jobData.Id,
                             "TruckId": truck.Id,
                             "DriverId": driver.Id]
                self.callAddDriverTrucj(param) { (data) in
                    if let data = data {
                        self.callGetDriverTruckList()
                    }
                }
               }
               delay(1.0) {
                   self.navigationController?.pushViewController(con2, animated: true)
               }
        }
        self.navigationController?.pushViewController(con1, animated: true)
    }
}


extension ReturnContainerDetailVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return truckDriverList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverTruckListCell") as! DriverTruckListCell
        let obj = truckDriverList[indexPath.row]
        cell.imgProfile.image = UIImage(named: "ic_profile_pic")
        cell.lblName.text = obj.DriverFirstName + " " + obj.DriverLastName
        cell.lblMobile.text = "Mobile No: \(obj.DriverPhoneNumber)"
        cell.lblTruckName.text = "Carrier: \(obj.TruckName)"
        cell.lblLicenseNo.text = "License: \(obj.TruckPlateNumber)"
        
        cell.blockDeleteClk = { () -> Void in
            self.callDeleteTruckDriveData(id: "\(obj.Id)") { (str) in
                if str == "true" {
                    self.truckDriverList.remove(at: indexPath.row)
                    tableView.reloadData()
                    self.callGetDriverTruckList()
                }
            }
        }
        
        cell.blockCommentClk = { () -> Void in
            self.driverJobCommentVC(id: obj.DriverId)
        }
        cell.blockJobRoutClk = { () -> Void in
            let controll = DriverBoard.instantiateViewController(withIdentifier: "ManageContainerRoutVC") as! ManageContainerRoutVC
            controll.jobId = self.jobData.Id
            controll.driverTruckId = obj.Id
            self.navigationController?.pushViewController(controll, animated: true)
        }
        cell.blockDriverLocClk = { () -> Void in
            let controll = DriverBoard.instantiateViewController(identifier: "JobDriverLocationMapVC") as! JobDriverLocationMapVC
            controll.driverId = obj.DriverId
            controll.jobData = self.jobData
            self.navigationController?.pushViewController(controll, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165.0
    }
    
    
    func driverJobCommentVC(id: Int) {
        let controll = MainBoard.instantiateViewController(withIdentifier: "CommentListVC") as! CommentListVC
        controll.jobData = self.jobData
        controll.driverId = id
        controll.isFromCarrier = true
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
}

extension ReturnContainerDetailVC : CLLocationManagerDelegate, MKMapViewDelegate
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
        mapManager.directionsUsingGoogle(from: CLLocationCoordinate2DMake(startLat, startLong), to: CLLocationCoordinate2DMake(endLat, endLong)){ (route, directionInformation, boundingRegion, error) in
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



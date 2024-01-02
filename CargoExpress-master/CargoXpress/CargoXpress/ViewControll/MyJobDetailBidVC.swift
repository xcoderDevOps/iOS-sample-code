//
//  MyJobDetailBidVC.swift
//  CargoXpress
//
//  Created by infolabh on 30/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import MapKit
import FloatRatingView

class MyJobDetailBidCell : UICollectionViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
}

class MyJobDetailBidVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var driverDetail: LetsView!
    @IBOutlet weak var lblStatus: UILabel!
    
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
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblExpressDate: UILabel!
    @IBOutlet weak var stackExpress: UIStackView!
    @IBOutlet weak var heightBtnTrackJob: NSLayoutConstraint!
    @IBOutlet weak var bidView: UIView!
    
    @IBOutlet weak var lblDriverDetail: UILabel!
    @IBOutlet weak var lblCarrierDetail: UILabel!
    
    @IBOutlet weak var stackCommodity: UIStackView!
    @IBOutlet weak var staclTotalPalate: UIStackView!
    
    @IBOutlet weak var stackContainer: UIStackView!
    @IBOutlet weak var stackCBM: UIStackView!
    
    @IBOutlet weak var jobPaymentView: LetsView!
    
    @IBOutlet weak var driverCommentView: LetsView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var ratingView: LetsView!
    
    @IBOutlet weak var ratingFeedbackView: LetsView!
    @IBOutlet weak var carrierFeedbackView: UIView!
    @IBOutlet weak var shipperFeedbackView: UIView!
    
    @IBOutlet weak var viewBillOfLoading: UIView!
    
    @IBOutlet weak var ratingShipper: FloatRatingView!
    @IBOutlet weak var lblRateShip: UILabel!
    
    @IBOutlet weak var ratingCarrier: FloatRatingView!
    @IBOutlet weak var lblRateCarrier: UILabel!
    
    var jobData = JobData()
    var bidArray = [JobBidData]()
    
    var locationManager: CLLocationManager!
    var mapManager = MapManager()
    var mapAnnotations : [CustomPointAnnotation]?
    
    var timer : Timer?
    
    var locationArray = [CLLocation]()
    
    var anView1 : LetsAnnotationView?
    let infoBindle = CustomPointAnnotation()
    
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
        
        title = "Job Details"
        backButton(color: UIColor.white)
        
        let layout = SJCenterFlowLayout()
        layout.itemSize = CGSize(width: 210, height: 210)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        //layout.minimumInteritemSpacing = 10
        layout.animationMode = SJCenterFlowLayoutAnimation.scale(sideItemScale: 0.8, sideItemAlpha: 0.8, sideItemShift: 0.0)
        collectionView.collectionViewLayout = layout
        
        ratingFeedbackView.isHidden = true
        carrierFeedbackView.isHidden = true
        shipperFeedbackView.isHidden = true
        
        updateJobStatus()
        getJobFromAPI()
        setMapDataView()
        
        if jobData.JobStatusId
            == 10 {
            setRatingReview()
        }
        
        rightBar = UIBarButtonItem(image: UIImage(named: "ic_share"), style: UIBarButtonItem.Style.done, target: self, action: #selector(shareJobPath))
        self.navigationItem.setRightBarButton(rightBar, animated: true)
        // Do any additional setup after loading the view.
    }
    var flag = true
    func setMapDataView() {
        mapAnnotations = [CustomPointAnnotation]()
        addMapAnotationPin(jobData.PickUpAddressLatitude.ns.doubleValue, long: jobData.PickUpAddressLongitude.ns.doubleValue, address: jobData.PickUpAddress, isStartAddress: true)
        addMapAnotationPin(jobData.DropOffAddressLatitude.ns.doubleValue, long: jobData.DropOffAddressLongitude.ns.doubleValue, address: jobData.DropOffAddress, isStartAddress: false)
        
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        if flag {
            flag = false
            DispatchQueue.main.async {
                self.mapView.fitAllAnnotations()
                UIView.animate(withDuration: 0.33) {
                    self.mapView.layoutIfNeeded()
                }
            }
        }
        
        
        //getDirectionsUsingApple(startLat: jobData.PickUpAddressLatitude.ns.doubleValue, startLong: jobData.PickUpAddressLongitude.ns.doubleValue, endLat: jobData.DropOffAddressLatitude.ns.doubleValue, endLong: jobData.DropOffAddressLongitude.ns.doubleValue)
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
    
    @objc func getJobFromAPI() {
        callGetJobDataFromjobID(url: baseURL+URLS.Job_ById.rawValue+"\(jobData.Id)") { (data) in
            if let data = data {
                self.jobData = data
                self.updateJobStatus()
            }
        }
    }

    func updateJobStatus() {
        bidView.isHidden = true
        driverDetail.isHidden = true
        viewStatus.isHidden = true
        driverCommentView.isHidden = true
        jobPaymentView.isHidden = true
        viewBillOfLoading.isHidden = true
        
        if jobData.JobStatusId > 4 {
            jobPaymentView.isHidden = false
        }
        
        if jobData.JobStatusId > 5 {
            driverDetail.isHidden = false
            driverCommentView.isHidden = false
        }
        heightBtnTrackJob.constant = 0.0
        if jobData.JobStatusId > 5 {
            heightBtnTrackJob.constant = 50.0 //TODO: 50.0
        }
        
        if jobData.JobStatusId > 2 {
            viewStatus.isHidden = false
            viewBillOfLoading.isHidden = false
        }
        
        if let status = JobStatus(rawValue : jobData.JobStatusId) {
            if status == .QuoteGeneration {
                bidView.isHidden = false
                callGetBidList(url: baseURL+URLS.JobBids_ByJobId.rawValue+"JobId=\(jobData.Id)") { (data) in
                    self.bidArray = data
                    self.collectionView.reloadData()
                }
            }
        }
        
        ratingView.isHidden = true
        if jobData.JobStatusId == 10 {
            ratingView.isHidden = false
            setRatingReview()
        }
        
        lblStatus.text = jobData.JobStatus
        lblDate.text = "Job No: \(jobData.JobNo)\nDate  : \(jobData.PickupDate)"
        lblType.text = jobData.TruckType
        lblFregile.text = jobData.IsFargile ? "Yes" : "No"
        lblExpress.text = jobData.IsExpres ? "Yes" : "No"
        lblContainers.text = "\(jobData.NoOfContainer) (\(distanceDateTime.containerHeight))"
        lblActualTon.text = "\(jobData.ActualTonage)"
        lblHsCode.text = jobData.HsCode
        lblCBM.text = "\(jobData.Cbm)"
        lblServiceType.text = jobData.TruckService
        lblTotalPallet.text = "\(jobData.TotalPallets)"
        lblCommodity.text = jobData.CommodityType
        lblpickUp.text = jobData.PickUpAddress
        lblDrop.text = jobData.DropOffAddress
        lblComment.text = jobData.SpecialMessage
        lblExpressDate.text = jobData.ExpressDate
        stackExpress.isHidden = !jobData.IsFargile
        lblDriverDetail.text = jobData.DriverName
        stackCommodity.isHidden = jobData.CommodityType.isEmpty
        staclTotalPalate.isHidden = jobData.TotalPallets == 0
        
        if !jobData.TruckPlate.isEmpty {
            lblCarrierDetail.isHidden = false
            lblCarrierDetail.text = "Number Plate: \(jobData.TruckPlate)\nCompany Name: \(jobData.CompanyName)"
        } else {
            lblCarrierDetail.isHidden = true
        }
        
        stackContainer.isHidden = jobData.NoOfContainer == 0
        stackCBM.isHidden = jobData.Cbm == 0
        
        if jobData.JobStatusId > 5 {
            self.callGetJobLocationData(jobId: "\(jobData.Id)", driverId: "\(jobData.DriverId)") { (data) in
                self.locationArray = []
                for obj in data {
                    let lat = obj.Latitude.ns.doubleValue
                    let long = obj.Longitude.ns.doubleValue
                    let loc = CLLocation(latitude: lat, longitude: long)
                    self.locationArray.append(loc)
                }
                self.removeAllPlacemarkFromMap(shouldRemoveUserLocation: true)
                
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
                self.setMapDataView()
                
//                DispatchQueue.main.async {
//                    self.mapView.fitAllAnnotations()
//                    UIView.animate(withDuration: 0.33) {
//                        self.mapView.layoutIfNeeded()
//                    }
//                }
                
//                if let loc = data.first {
//                    let lat = loc.Latitude.ns.doubleValue
//                    let long = loc.Longitude.ns.doubleValue
//                    let loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                    if self.mapView.annotations.contains(where: { (anotation) -> Bool in
//                        if anotation.coordinate.latitude == self.infoBindle.coordinate.latitude && anotation.coordinate.longitude == self.infoBindle.coordinate.longitude {
//                            return true
//                        }
//                        return false
//                    }) {
//                        self.infoBindle.coordinate = loc
//                        self.anView1?.moveAnnotation(self.infoBindle.coordinate)
//                    } else {
//                        self.addPolylineToMap(locations: self.locationArray)
//                        self.infoBindle.coordinate = loc
//
//                        self.infoBindle.imageName = "bindle_pin"
//                        self.mapView.addAnnotation(self.infoBindle)
//                    }
//                    //self.addPolylineToMap(locations: self.locationArray)
//                }
            }
        }
        
    }
    
    func setRatingReview() {
        let url = baseURL + URLS.JobRatingListing.rawValue + "\(jobData.Id)"
        callRatingistListAPI(url: url) { (data) in
            if let shipperCom = data.filter({$0.UserType == "2"}).first {
                self.ratingView.isHidden = true
                self.shipperFeedbackView.isHidden = false
                self.ratingFeedbackView.isHidden = false
                self.ratingShipper.rating = shipperCom.RatingToShipper.ns.doubleValue
                self.lblRateShip.text = shipperCom.CommentToShipper
                
            }
            if let carrierCom = data.filter({$0.UserType == "3"}).first {
                self.ratingView.isHidden = true
                self.carrierFeedbackView.isHidden = false
                self.ratingFeedbackView.isHidden = false
                self.ratingCarrier.rating = carrierCom.RatingToShipper.ns.doubleValue
                self.lblRateCarrier.text = carrierCom.CommentToShipper
            }
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
    
    @IBAction func btnUploadBillOfLoading(_ sender: UIButton) {
        let controll = MainBoard.instantiateViewController(identifier: "BillOfLoadingVC") as! BillOfLoadingVC
        controll.jobId = "\(jobData.Id)"
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    @IBAction func btnJobStaticTrack(_ sender: UIButton) {
        let controll = MainBoard.instantiateViewController(withIdentifier: "JobStatusActivityVC") as! JobStatusActivityVC
        controll.jobId = "\(jobData.Id)"
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    @IBAction func driverJobCommentVC(_ sender: UIButton) {
        let controll = MainBoard.instantiateViewController(withIdentifier: "CommentListVC") as! CommentListVC
        controll.jobData = self.jobData
        controll.isFromCarrier = false
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    @IBAction func btnTapToTrackJobCLK(_ sender: UIButton) {
        callGetRootData(jobId: "\(self.jobData.Id)") { (data) in
            
            if let first = data.first {
                self.callGetRootDetailData(rootId: "\(first.Id)") { (detailData) in
                    _ = displayViewController(SLpopupViewAnimationType.bottomTop, nibName: "PopupTrackJobVC", blockOK: nil, blockCancel: {
                        appDelegate.window?.rootViewController?.dismissPopupViewController(.topBottom)
                    }, objData: detailData as AnyObject)
                }
            }
            else {
                showAlert("Track Data Not Available")
            }
        }
    }
    
    @IBAction func btnJobPaymentCLK(_ sender: UIButton) {
        let controll = MainBoard.instantiateViewController(identifier: "PaymentVC") as! PaymentVC
        controll.jobId = "\(jobData.Id)"
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    @IBAction func btnRateJobCLK(_ sender: UIButton) {
        _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupRatingVC", blockOK: { (data) in
            dismissPopUp()
        }, blockCancel: {
            dismissPopUp()
        }, objData: jobData as AnyObject)
    }
    
}

extension MyJobDetailBidVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bidArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyJobDetailBidCell", for: indexPath) as! MyJobDetailBidCell
        let obj = bidArray[indexPath.row]
        cell.lblName.text = obj.CarrierName
        cell.lblPrice.text = "[ Price : $\(obj.Price)]"
        cell.imgProfile.image = #imageLiteral(resourceName: "ic_profile_pic")
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupSelectBidVC", blockOK: { (obj) in
            dismissPopUp()
            
            let controll = MainBoard.instantiateViewController(identifier: "JobPaymentVC") as! JobPaymentVC
            controll.jobData = self.jobData
            controll.jobBidData = self.bidArray[indexPath.row]
            self.navigationController?.pushViewController(controll, animated: true)
            
        }, blockCancel: {
            dismissPopUp()
        }, objData: bidArray[indexPath.row] as AnyObject)
    }
}

extension MyJobDetailBidVC : CLLocationManagerDelegate, MKMapViewDelegate
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

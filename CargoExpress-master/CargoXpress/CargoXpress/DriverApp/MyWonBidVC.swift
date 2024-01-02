//
//  MyWonBidVC.swift
//  CargoXpress
//
//  Created by infolabh on 08/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import MapKit
import PDFKit
import MobileCoreServices
import FloatRatingView

class DriverTruckListCell : UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblTruckName: UILabel!
    @IBOutlet weak var lblLicenseNo: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnDrivLoc: UIButton!
    @IBOutlet weak var btnJobRoute: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnTruckLoc: UIButton!
    
    var blockDeleteClk : (()->())?
    
    var blockDriverLocClk : (()->())?
    var blockJobRoutClk : (()->())?
    var blockCommentClk : (()->())?
    var blockTruckLocationClk : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnDrivLoc.titleLabel?.numberOfLines = 0
        btnJobRoute.titleLabel?.numberOfLines = 0
        btnComment.titleLabel?.numberOfLines = 0
        btnTruckLoc.titleLabel?.numberOfLines = 0
        btnDrivLoc.titleLabel?.textAlignment = .center
        btnJobRoute.titleLabel?.textAlignment = .center
        btnComment.titleLabel?.textAlignment = .center
        btnTruckLoc.titleLabel?.textAlignment = .center
    }
    
    @IBAction func btnDeleteCard(_ sender: UIButton) {
        if blockDeleteClk != nil {
            blockDeleteClk!()
        }
    }
    
    @IBAction func btnDriverLocationClk(_ sender: UIButton) {
        if blockDriverLocClk != nil {
            blockDriverLocClk!()
        }
    }
    
    @IBAction func btnJobRouteClk(_ sender: UIButton) {
        if blockJobRoutClk != nil {
            blockJobRoutClk!()
        }
    }
    
    @IBAction func btnCommentClk(_ sender: UIButton) {
        if blockCommentClk != nil {
            blockCommentClk!()
        }
    }
    
    @IBAction func btnViewTruckLocationClk(_ sender: UIButton) {
        if blockTruckLocationClk != nil {
            blockTruckLocationClk!()
        }
    }
}

class MyWonBidVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var driverDetail: LetsView!
//    @IBOutlet weak var carrierDetail: LetsView!
    @IBOutlet weak var amountView: LetsView!
    
    @IBOutlet weak var jobPaymentView: LetsView!
    
    var jobData = JobData()
    
    var locationManager: CLLocationManager!
    var mapManager = MapManager()
    var mapAnnotations : [CustomPointAnnotation]?
    
    @IBOutlet weak var lblServiceType: UILabel!
    @IBOutlet weak var lblTruckType: UILabel!
    @IBOutlet weak var JobInfo: UILabel!
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var extraInfo: UILabel!
    
    @IBOutlet weak var btnJobAction: UIButton!
    
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblDropOff: UILabel!
    
//    @IBOutlet weak var lblDriveName: UILabel!
//    @IBOutlet weak var lblDriveMobile: UILabel!
//    @IBOutlet weak var lblCarrierNum: UILabel!
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
//    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblJobNo: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewUploadDoc: LetsView!
    @IBOutlet weak var imgListView: LetsView!
    
//    @IBOutlet weak var driverCommentView: LetsView!
//    @IBOutlet weak var viewTrackLoc: LetsView!
//    @IBOutlet weak var viewChangeDriveCarrier: LetsView!
    
    @IBOutlet weak var viewBillOfload: LetsView!
    @IBOutlet weak var ratingView: LetsView!
    
    @IBOutlet weak var ratingFeedbackView: LetsView!
    @IBOutlet weak var carrierFeedbackView: UIView!
    @IBOutlet weak var shipperFeedbackView: UIView!
    
    @IBOutlet weak var ratingShipper: FloatRatingView!
    @IBOutlet weak var lblRateShip: UILabel!
    
    @IBOutlet weak var ratingCarrier: FloatRatingView!
    @IBOutlet weak var lblRateCarrier: UILabel!
    
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet weak var tableDriverTruck: UITableView!
    
    @IBOutlet weak var viewAddDriverTruck: LetsView!
    @IBOutlet weak var viewDriverCarierTable: UIView!
    var truckDriverList = [TruckDriverComboData]() {
        didSet {
            self.viewDriverCarierTable.isHidden  = self.truckDriverList.isEmpty
            self.heightTableView.constant = CGFloat(Double(self.truckDriverList.count) * 165.0) + 16.0
        }
    }
    
    var locationArray = [CLLocation]()
    
    var anView1 : LetsAnnotationView?
    
    struct DocData {
        var data : Data?
        var thumg : UIImage?
        var img : UIImage?
        var ext = ""
    }
    var docDataArray = [DocData]() {
        didSet {
            imgListView.isHidden = docDataArray.isEmpty
        }
    }
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
        lblServiceType.text = "Service Type: \(jobData.TruckService)"
        lblTruckType.text = jobData.TruckType
        
        lblJobNo.text = "Job No: \(jobData.JobNo)"
        
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
        
        if jobData.SpecialMessage.isEmpty {
            infoTitle.isHidden = true
            extraInfo.isHidden = true
        } else {
            infoTitle.isHidden = false
            extraInfo.isHidden = false
            extraInfo.text = jobData.SpecialMessage
        }
        
        lblDate.text = "--"
        if let dateStr = jobData.PickupDate.components(separatedBy: " ").first {
            lblDate.text = "\(dateStr)"
        }
        
        lblDistance.text = "--"
        if jobData.Distance > 0.0 {
            lblDistance.text = String(format: "%.2f Km", jobData.Distance)
        }
        
        JobInfo.text = arrayData.joined(separator: "\n")
        
        lblPickUp.text = jobData.PickUpAddress
        lblDropOff.text = jobData.DropOffAddress
        
        imgListView.isHidden =  true
        self.amountView.isHidden  = true
        
//        self.driverDetail.isHidden  = true
//        self.carrierDetail.isHidden  = true
        
//        driverCommentView.isHidden  = true
//        viewTrackLoc.isHidden  = true
        viewDriverCarierTable.isHidden  = true
        viewAddDriverTruck.isHidden = true
        mapAnnotations = [CustomPointAnnotation]()
        addMapAnotationPin(jobData.PickUpAddressLatitude.ns.doubleValue, long: jobData.PickUpAddressLongitude.ns.doubleValue, address: jobData.PickUpAddress, isStartAddress: true)
        addMapAnotationPin(jobData.DropOffAddressLatitude.ns.doubleValue, long: jobData.DropOffAddressLongitude.ns.doubleValue, address: jobData.DropOffAddress, isStartAddress: false)
        DispatchQueue.main.async {
            self.mapView.fitAllAnnotations()
        }
        

        rightBar = UIBarButtonItem(image: UIImage(named: "ic_share"), style: UIBarButtonItem.Style.done, target: self, action: #selector(shareJobPath))
        self.navigationItem.setRightBarButton(rightBar, animated: true)
        
        //getDirectionsUsingApple(startLat: jobData.PickUpAddressLatitude.ns.doubleValue, startLong: jobData.PickUpAddressLongitude.ns.doubleValue, endLat: jobData.DropOffAddressLatitude.ns.doubleValue, endLong: jobData.DropOffAddressLongitude.ns.doubleValue)
        getJobFromAPI()
        
        ratingFeedbackView.isHidden = true
        carrierFeedbackView.isHidden = true
        shipperFeedbackView.isHidden = true
        
        if jobData.JobStatusId
            == 10 {
            setRatingReview()
        }
        
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
    
    @IBAction func btnJobPaymentCLK(_ sender: UIButton) {
        let controll = MainBoard.instantiateViewController(identifier: "PaymentVC") as! PaymentVC
        controll.jobId = "\(jobData.Id)"
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    @IBAction func btnBillOfLoadingCLK(_ sender: LetsButton) {
        let controll = MainBoard.instantiateViewController(identifier: "BillOfLoadingVC") as! BillOfLoadingVC
        controll.jobId = "\(jobData.Id)"
        self.navigationController?.pushViewController(controll, animated: true)
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
//        self.driverDetail.isHidden  = true
//        self.carrierDetail.isHidden  = true
        self.amountView.isHidden  = true
        imgListView.isHidden =  true
        
//        driverCommentView.isHidden  = true
//        viewChangeDriveCarrier.isHidden = true
//        viewTrackLoc.isHidden = true
        
        if let status = JobStatus(rawValue : jobData.JobStatusId) {
            btnJobAction.isHidden = true
            switch status {
            case .QuoteAccepted:
                btnJobAction.isHidden = false
                btnJobAction.setTitle("Start Job", for: UIControl.State.normal)
                break
            case .JobStarted:
                btnJobAction.isHidden = false
                imgListView.isHidden = docDataArray.isEmpty
                btnJobAction.setTitle("Clearance In Progress", for: UIControl.State.normal)
                break
            case .ClearanceInProgress:
                btnJobAction.isHidden = false
                btnJobAction.setTitle("Assign Driver & Truck", for: UIControl.State.normal)
                break
            case .TruckAssigned:
                btnJobAction.isHidden = false
//                driverCommentView.isHidden  = false
//                viewChangeDriveCarrier.isHidden = false
                btnJobAction.setTitle("Truck - Enroute", for: UIControl.State.normal)
                break
            case .TruckEnroute:
                btnJobAction.isHidden = false
//                driverCommentView.isHidden  = false
//                viewTrackLoc.isHidden = false
//                viewChangeDriveCarrier.isHidden = false
                btnJobAction.setTitle("Arrive At Destination", for: UIControl.State.normal)
                break
            case .ArrivedAtDestination:
                btnJobAction.isHidden = false
//                driverCommentView.isHidden  = false
//                viewTrackLoc.isHidden = false
//                viewChangeDriveCarrier.isHidden = false
                btnJobAction.setTitle("Arrive At Drop-off Location", for: UIControl.State.normal)
                break
            case .ArrivedAtDropOff:
                btnJobAction.isHidden = false
//                driverCommentView.isHidden  = false
//                viewTrackLoc.isHidden = false
//                viewChangeDriveCarrier.isHidden = false
                btnJobAction.setTitle("Job Complete", for: UIControl.State.normal)
                break
            case .JobCompleted:
                btnJobAction.isHidden = true
//                driverCommentView.isHidden  = false
//                viewTrackLoc.isHidden = false
                break
            case .Cancelled:
                btnJobAction.isHidden = true
                break
            case .QuoteRequest:
                btnJobAction.isHidden = true
                break
            case .QuoteGeneration:
                btnJobAction.isHidden = true
                break
            case .NewJobReturn:
                break
            case .OngoingJobReturn:
                break
            case .CompletedJobReturn:
                break
            }
        }
        
//        if !jobData.DriverName.isEmpty {
//            driverDetail.isHidden = false
//            lblDriveName.text = jobData.DriverName
//            lblDriveMobile.text = jobData.DriverPhone
//        }
        
//        if !jobData.TruckPlate.isEmpty {
//            self.carrierDetail.isHidden  = false
//            var arr = [String]()
//            arr.append("Number Plate: \(jobData.TruckPlate)")
//            arr.append("Company Name: \(jobData.CompanyName)")
//            lblCarrierNum.text = arr.joined(separator: "\n")
//        }
        
        jobPaymentView.isHidden = true
        if jobData.JobStatusId > 4 {
            jobPaymentView.isHidden = false
        }
        
        if jobData.JobStatusId > 5 {
            viewAddDriverTruck.isHidden = false
            self.callTruckDriverListAPI(job_id: "\(self.jobData.Id)") { (data) in
                self.truckDriverList.removeAll()
                self.truckDriverList.append(contentsOf: data)
                self.tableDriverTruck.reloadData()
            }
        }
        
        ratingView.isHidden = true
        if jobData.JobStatusId == 10 {
            ratingView.isHidden = false
            self.setRatingReview()
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
    
    @IBAction func btnStartJob(_ sender: UIButton) {
        if jobData.JobStatusId == 9 {
            _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupReturnContainer", blockOK: { (flag) in
                dismissPopUp()
                if let flag = flag as? Bool {
                    let param = ["CarrierId":UserInfo.savedUser()!.Id,
                                 "ParentId":self.jobData.Id,
                                 "IsSamePath":flag ? "true":"false"] as [String : Any]
                    self.callAddJob(url: baseURL+URLS.Job_Insert.rawValue, param) { (data) in
                        if data != nil {
                            print(data)
                            showAlert("Job placed successfully")
                            self.alertShow(self, title: "", message: "Are you sure you want to change the status?", okStr: "Yes", cancelStr: "No", okClick: {
                                self.changeStatus()
                            }, cancelClick: nil)
                        }
                    }
                }
                
            }, blockCancel: {
                dismissPopUp()
                self.changeStatus()
            }, objData: nil)
        } else {
            self.alertShow(self, title: "", message: "Are you sure you want to change the status?", okStr: "Yes", cancelStr: "No", okClick: {
                self.changeStatus()
            }, cancelClick: nil)
        }
        
    }
    
    @IBAction func btnRateJobCLK(_ sender: UIButton) {
        _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupRatingVC", blockOK: { (data) in
            dismissPopUp()
        }, blockCancel: {
            dismissPopUp()
        }, objData: jobData as AnyObject)
    }
    
    func changeStatus() {
        if let status = JobStatus(rawValue : jobData.JobStatusId) {
            if status == .QuoteAccepted {
                let url = baseURL+URLS.JobStart.rawValue
                let param = ["Id":jobData.Id]
                calChangeJobStatus(url: url, param) { (data) in
                    if let data = data {
                        self.jobData = data
                        self.getJobFromAPI()
                    }
                }
            } else if status == .ArrivedAtDropOff {
                 let url = baseURL+URLS.JobEnd.rawValue
                 let param = ["Id":jobData.Id]
                 calChangeJobStatus(url: url, param) { (data) in
                     if let data = data {
                         self.jobData = data
                         self.getJobFromAPI()
                     }
                 }
            } else if status == .ClearanceInProgress {
                let con1 = DriverBoard.instantiateViewController(identifier: "DriverListVC") as! DriverListVC
                   con1.isFromWon = true
                   con1.jobId = self.jobData.Id
                   con1.blockAssignDrtiver = { (job) -> Void in
                       let con2 = DriverBoard.instantiateViewController(identifier: "CarrierListVC") as! CarrierListVC
                       con2.isFromWon = true
                      con2.jobId = self.jobData.Id
                       con2.blockAssignCareer = { (truck) -> Void in
                            self.jobData = job
                            self.jobStatusChage(status: self.jobData.JobStatusId+1)
                       }
                
                       delay(1.0) {
                           self.navigationController?.pushViewController(con2, animated: true)
                       }
                }
                self.navigationController?.pushViewController(con1, animated: true)
            } else if status == .JobStarted {
                self.index = 0
                if docDataArray.count  > 0 {
                    self.uploadImage()
                } else {
                    self.jobStatusChage(status: self.jobData.JobStatusId+1)
                }
            }
            else {
                self.jobStatusChage(status: jobData.JobStatusId+1)
            }
        }
    }
    
    var index = 0
    func uploadImage() {
        let param = [
            "JobId":"\(self.jobData.Id)",
            "UserType":"2",
            "DocumentTypeId":"7"]
        
        callUploadImage(url: baseURL+URLS.JobDocuments_Upsert.rawValue, param: param, data: docDataArray[index]) { (data) in
            if data != nil {
                self.index = self.index + 1
                if self.docDataArray.count == self.index {
                    showAlert("Job Assigned Successfully")
                    self.jobStatusChage(status: self.jobData.JobStatusId+1)
                } else {
                    self.uploadImage()
                }
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
    
    @IBAction func btnUploadDocCLK(_ sender: UIButton) {
        self.choosePicker()
    }
    
    
    @IBAction func tapOnTrackJobActivity(_ sender: UIButton) {
        let controll = MainBoard.instantiateViewController(withIdentifier: "JobStatusActivityVC") as! JobStatusActivityVC
        controll.jobId = "\(jobData.Id)"
        self.navigationController?.pushViewController(controll, animated: true)
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
                        self.truckDriverList.append(data)
                        self.tableDriverTruck.reloadData()
                    }
                }
               }
               delay(1.0) {
                   self.navigationController?.pushViewController(con2, animated: true)
               }
        }
        self.navigationController?.pushViewController(con1, animated: true)
    }
    
    
//    @IBAction func btnChangeCarrier(_ sender: LetsButton) {
//        let con2 = DriverBoard.instantiateViewController(identifier: "CarrierListVC") as! CarrierListVC
//        con2.isFromWon = true
//        con2.jobId = self.jobData.Id
//        con2.blockAssignCareer = { (truck) -> Void in
//            self.getJobFromAPI()
//        }
//        self.navigationController?.pushViewController(con2, animated: true)
//
//    }
//
//    @IBAction func btnChangeDriver(_ sender: LetsButton) {
//        let con1 = DriverBoard.instantiateViewController(identifier: "DriverListVC") as! DriverListVC
//        con1.isFromWon = true
//        con1.jobId = self.jobData.Id
//        con1.blockAssignDrtiver = { (job) -> Void in
//            self.getJobFromAPI()
//        }
//        self.navigationController?.pushViewController(con1, animated: true)
//    }
}


extension MyWonBidVC : CLLocationManagerDelegate, MKMapViewDelegate
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


extension MyWonBidVC :UINavigationControllerDelegate, UIImagePickerControllerDelegate , UIDocumentPickerDelegate{
    func choosePicker() {
        let alertController = UIAlertController(title: "CargoXpress", message: "Select an option to choose photo", preferredStyle: (IS_IPAD ? UIAlertController.Style.alert : UIAlertController.Style.actionSheet))
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action -> Void in
        })
        let doc = UIAlertAction(title: "Choose Document", style: UIAlertAction.Style.default
            , handler: { action -> Void in
                self.openDoucment()
        })
        let gallery = UIAlertAction(title: "Choose Photo", style: UIAlertAction.Style.default
            , handler: { action -> Void in
                self.openPicker(isCamera: false)
        })
        let camera = UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default
            , handler: { action -> Void in
                self.openPicker(isCamera: true)
        })
        
        alertController.addAction(doc)
        alertController.addAction(camera)
        alertController.addAction(gallery)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func openPicker(isCamera : Bool){
        
        let picker:UIImagePickerController?=UIImagePickerController()
        
        if isCamera {
            picker!.sourceType = UIImagePickerController.SourceType.camera
        }else{
            picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        }
        picker?.delegate = self
        //picker?.allowsEditing = true
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.present(picker!, animated: true, completion: nil)
        } else{
            picker!.modalPresentationStyle = .popover
            present(picker!, animated: true, completion: nil)//4
            picker!.popoverPresentationController?.sourceView = collectionView
            picker!.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
            picker!.popoverPresentationController?.sourceRect = CGRect(x: 40, y: 80, width: 0, height: 0)
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if (info[UIImagePickerController.InfoKey.mediaType] as! String)  == "public.image"
        {
            let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            var docData = DocData()
            docData.img = img
            self.docDataArray.append(docData)
            self.collectionView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func openDoucment() {
        let types: [String] = [String(kUTTypePDF)]
        let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {return}
        if let fileN = (url.absoluteString as NSString).lastPathComponent.removingPercentEncoding {
            let arr = fileN.components(separatedBy: ".")
            var docData = DocData()
            if let ext = arr.last {
                docData.ext = ext
            }
            do {
                docData.data  = try Data(contentsOf: url)
                docData.thumg = generatePdfThumbnail(of: CGSize(width: 100.0, height: 100.0), for: url, atPage: 0)
                self.docDataArray.append(docData)
                self.collectionView.reloadData()
            } catch {}
            
        }
    }
    
    
    func generatePdfThumbnail(of thumbnailSize: CGSize , for documentUrl: URL, atPage pageIndex: Int) -> UIImage? {
        let pdfDocument = PDFDocument(url: documentUrl)
        let pdfDocumentPage = pdfDocument?.page(at: pageIndex)
        return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
    }
}

extension MyWonBidVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return docDataArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "AddPostCell", for: indexPath) as! AddPostCell
        if indexPath.row == 0 {
            cell.btnDelete.isHidden = true
            cell.imgView.image = #imageLiteral(resourceName: "ic_camera")
            cell.imgView.contentMode = .center
        } else {
            cell.btnDelete.isHidden = false
            if let img = docDataArray[indexPath.row-1].img {
                cell.imgView.image = img
            } else if let img = docDataArray[indexPath.row-1].thumg {
                cell.imgView.image = img
            } else {
                cell.imgView.image = nil
            }
            
            cell.imgView.contentMode = .scaleToFill
        }
        cell.blockDeleteImage = { () -> Void in
            self.docDataArray.remove(at: indexPath.row-1)
            self.collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.choosePicker()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100.0, height: 100.0)
    }
}

extension MyWonBidVC : UITableViewDelegate, UITableViewDataSource {
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
                if str == "200" {
                    self.truckDriverList.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }
        }
        cell.blockCommentClk = { () -> Void in
            self.driverJobCommentVC(id: obj.DriverId)
        }
        cell.blockJobRoutClk = { () -> Void in
            self.getJobRootData(obj.Id)
        }
        cell.blockDriverLocClk = { () -> Void in
            let controll = DriverBoard.instantiateViewController(identifier: "JobDriverLocationMapVC") as! JobDriverLocationMapVC
            controll.driverId = obj.DriverId
            controll.jobData = self.jobData
            self.navigationController?.pushViewController(controll, animated: true)
        }
        cell.blockTruckLocationClk = { () -> Void in
            let controll = DriverBoard.instantiateViewController(identifier: "TruckStandAloneLocationVC") as! TruckStandAloneLocationVC
            let tData = TruckData()
            tData.Id = obj.TruckId
            controll.truckData = tData
            controll.jobId = "\(obj.Id)"
            self.navigationController?.pushViewController(controll, animated: true)
            
        }
        return cell
    }
    
    
    func getJobRootData(_ id: Int) {
        callGetRootData(jobId: "\(id)") { (data) in //self.jobData.Id
            
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
    
    func driverJobCommentVC(id: Int) {
        let controll = MainBoard.instantiateViewController(withIdentifier: "CommentListVC") as! CommentListVC
        controll.jobData = self.jobData
        controll.driverId = id
        controll.isFromCarrier = true
        self.navigationController?.pushViewController(controll, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 165.0
    }
}



extension MKMapView {
    func fitAllAnnotations() {
        var zoomRect = MKMapRect.null;
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.1, height: 0.1);
            zoomRect = zoomRect.union(pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
    }
}

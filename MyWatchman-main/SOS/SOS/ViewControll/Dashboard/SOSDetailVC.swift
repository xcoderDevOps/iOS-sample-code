//
//  SOSDetailVC.swift
//  SOS
//
//  Created by Alpesh Desai on 31/12/20.
//

import UIKit
import GoogleMaps
import Kingfisher

class SOSDetailVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblStaffName: UILabel!
    @IBOutlet weak var lblStaffPosition: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblSosRaisedOn: UILabel!
    @IBOutlet weak var lblSosType: UILabel!
    @IBOutlet weak var lblEstimationTime: UILabel!
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var lblStafNotAssign: UILabel!
    @IBOutlet weak var stackStaffDetail: UIStackView!
    
    var mobileNo = ""
    var sosId = 0
    var timer : Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SOS Detail"
        bgView.isHidden = true
        mapView.mapType = .satellite
        backButton()
        timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(callAPI(flag:)), userInfo: nil, repeats: true)
        timer.fire()
        callAPI(flag: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        timer = nil
    }
    
    @objc func callAPI(flag:Bool) {
        callGetSOS(id: sosId, flag: flag) { (data) in
            if let data = data {
                self.setupData(data: data)
            }
        }
    }
    
    func minutesToHoursAndMinutes (_ minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
    func setupData(data:SOSHistoryData) {
        bgView.isHidden = false
        lblStaffName.text = data.RoamingStaffName
        lblStaffPosition.text = "Position: \(data.RoamingStaffPosition)"
        lblContactNo.text = data.RoamingStaffPhone
        lblSosRaisedOn.text = "\(data.StartDate) to \(data.EndDate)"
        lblSosType.text = data.SOSType
        let tuple = minutesToHoursAndMinutes(data.CompletedSOSInMin.ns.integerValue)
        
        
        if let str = data.RoamingStaffImageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: str), !data.RoamingStaffImageUrl.isEmpty {
            let source = ImageResource(downloadURL: url)
            self.imgProfile.kf.setImage(with: source, placeholder:UIImage(named: "ic_profile"))
        }
        
        self.mapView.clear()
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: data.Latitude.ns.doubleValue, longitude: data.Longitude.ns.doubleValue)
        marker.map = self.mapView
        marker.icon = UIImage(named: "marker")
        
        if data.RoamingStaffId != 0 {
            lblEstimationTime.text = data.CompletedSOSInMin.ns.integerValue > 60 ? "\(tuple.hours) hour \(tuple.leftMinutes) mins" : "\(data.CompletedSOSInMin.ns.integerValue) mins"
            
            lblStafNotAssign.isHidden = true
            stackStaffDetail.isHidden = false
            let marker1 = GMSMarker()
            marker1.position = CLLocationCoordinate2D(latitude: data.RoamingStaffLat.ns.doubleValue, longitude: data.RoamingStaffLong.ns.doubleValue)
            marker1.map = self.mapView
            marker1.icon = UIImage(named: "bikepin")
            
            mobileNo = data.Mobile
            
            self.fetchRoute(from: CLLocationCoordinate2D(latitude: data.RoamingStaffLat.ns.doubleValue, longitude: data.RoamingStaffLong.ns.doubleValue), to: CLLocationCoordinate2D(latitude: data.Latitude.ns.doubleValue, longitude: data.Longitude.ns.doubleValue))
        } else {
            lblEstimationTime.text = "-"
            lblStafNotAssign.isHidden = false
            stackStaffDetail.isHidden = true
            self.mapView.camera = GMSCameraPosition.init(target: marker.position, zoom: 15.0)
        }
        
        
    }
    
    @IBAction func btnCallClk(_ sender: UIButton) {
        if !mobileNo.isEmpty {
            UIApplication.shared.canOpenURL(URL(string: "tel://\(mobileNo)")!)
        }
    }
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=\(GooglePlaceKey)")!
        print(url)
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                print("error in JSONSerialization")
                return
            }
            
            guard let routes = jsonResponse["routes"] as? [Any] else {
                return
            }
            guard routes.count > 0 else {
                return
            }
            guard let route = routes[0] as? [String: Any] else {
                return
            }

            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }
            
            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            
            //Call this method to draw path on map
            DispatchQueue.main.async {
                self.drawPath(from: polyLineString)
            }
            
        })
        task.resume()
    }
    
    func drawPath(from polyStr: String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapView // Google MapView
        
        let bounds = GMSCoordinateBounds(path: path!)
          self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
    }
    
    @IBAction func zoomOut(_ sender: AnyObject) {
        let zoomOutValue = mapView.camera.zoom - 1.0
        mapView.animate(toZoom: zoomOutValue)
    }
        
    @IBAction func zoomIn(_ sender: AnyObject) {
        let zoomInValue = mapView.camera.zoom + 1.0
        mapView.animate(toZoom: zoomInValue)
    }
}

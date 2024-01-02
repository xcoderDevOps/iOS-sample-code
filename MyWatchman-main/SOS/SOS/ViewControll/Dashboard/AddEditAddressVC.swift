//
//  AddEditAddressVC.swift
//  SOS
//
//  Created by Alpesh Desai on 29/12/20.
//

import UIKit
import GoogleMaps

class AddEditAddressVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var txtAddress: LetsTextField!
    @IBOutlet weak var pinImg: UIImageView!
    
    var location : CLLocation?
    var addressData : AddressListData?
    var addressStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        mapView.isMyLocationEnabled = true
        mapView.mapType = .satellite
        mapView.delegate = self
        pinImg.isHidden = true
        if let data = addressData {
            let loc = CLLocation(latitude: data.Latitude.ns.doubleValue, longitude: data.Longitude.ns.doubleValue)
            addressStr = data.Address
            txtAddress.text = data.AddressName
            title = "Edit Address"
            self.location = loc
            
            self.mapView.camera = GMSCameraPosition.init(target: loc.coordinate, zoom: 17.0)
            pinImg.isHidden = false
           // self.setupMarker(loc: loc)
        } else {
            title = "Add Address"
            appDelegate.setupLocationManager() { (loc) in
                self.getAddressFromLatLong(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude) { (address) in
                    var arr = [String]()
                    if !address.street.isEmpty {arr.append(address.street)}
                    if !address.areaName.isEmpty {arr.append(address.areaName)}
                    if !address.city.isEmpty {arr.append(address.city)}
                    self.addressStr = arr.joined(separator: ", ")
                    self.location = CLLocation(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
                    self.mapView.camera = GMSCameraPosition.init(target: self.location!.coordinate, zoom: 17.0)
                    self.pinImg.isHidden = false
                    //self.setupMarker(loc: self.location!)
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }

//    func setupMarker(loc: CLLocation) {
////        mapView.clear()
////        let marker = GMSMarker()
////        marker.position = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
////        marker.isDraggable = true
////        marker.map = self.mapView
////        marker.icon = UIImage(named: "marker_52")
//        self.mapView.camera = GMSCameraPosition.init(target: loc.coordinate, zoom: 15.0)
//    }
    
    
    @IBAction func zoomOut(_ sender: AnyObject) {
        let zoomOutValue = mapView.camera.zoom - 1.0
        mapView.animate(toZoom: zoomOutValue)
    }
        
    @IBAction func zoomIn(_ sender: AnyObject) {
        let zoomInValue = mapView.camera.zoom + 1.0
        mapView.animate(toZoom: zoomInValue)
    }
    
    @IBAction func btnAddAddressClk(_ sender: UIButton) {
        guard let loc = location else {
            return
        }
        self.view.endEditing(true)
        var param = ["CustomerId":UserInfo.savedUser()!.Id,
                     "AddressName":txtAddress.text!,
                     "Address": addressStr,
                     "Latitude" :loc.coordinate.latitude ,
                     "Longitude":loc.coordinate.longitude] as [String : Any]
        if let data = self.addressData {
            param["Id"] = data.Id
        }
        callAddAddress(param: param) { (data) in
            if let data = data {
                AddressVC.refresh = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AddEditAddressVC : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("Position of marker is = \(position.target.latitude),\(position.target.longitude)")
        self.getAddressFromLatLong(latitude: position.target.latitude, longitude: position.target.longitude) { (address) in
            var arr = [String]()
            if !address.street.isEmpty {arr.append(address.street)}
            if !address.areaName.isEmpty {arr.append(address.areaName)}
            if !address.city.isEmpty {arr.append(address.city)}
            self.addressStr = arr.joined(separator: ", ")
            self.location = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
            self.mapView.camera = GMSCameraPosition.init(target: self.location!.coordinate, zoom: mapView.camera.zoom)
        }
    }
}

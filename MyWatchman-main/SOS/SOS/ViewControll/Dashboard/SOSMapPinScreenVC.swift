//
//  SOSMapPinScreenVC.swift
//  SOS
//
//  Created by Alpesh Desai on 29/12/20.
//

import UIKit
import GoogleMaps

class SOSMapPinScreenVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = .satellite
        let url = baseURL + URLS.GetSOSById.rawValue + "\(id)"
        callGetSOSRatingDetail(url: url) { (data) in
            if let data = data {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: data.Latitude.ns.doubleValue, longitude: data.Longitude.ns.doubleValue)
                marker.isDraggable = true
                marker.isDraggable = true
                marker.map = self.mapView
                marker.icon = UIImage(named: "marker_52")
                self.mapView.camera = GMSCameraPosition.init(target: marker.position, zoom: 15.0)
            }
        }
        // Do any additional setup after loading the view.
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

import UIKit
import MapKit

class LetsAnnotation: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class LetsAnnotationView : MKAnnotationView, CAAnimationDelegate{
    var mapView : MKMapView?
    var lastReportedLocation : CLLocationCoordinate2D?
    var previousPoint : CLLocationCoordinate2D?
    func moveAnnotation(_ location: CLLocationCoordinate2D) {
        lastReportedLocation = location
        setPosition(lastReportedLocation!)
    }
    
    func setPosition(_ posValue: CLLocationCoordinate2D) {
        //extract the mapPoint from this dummy (wrapper) CGPoint struct
        let mapPoint: MKMapPoint = MKMapPoint(posValue)
        let toPos: CGPoint = self.mapView!.convert(posValue, toPointTo: self.mapView)
        if let previousPoint = previousPoint {
            let pPoint = MKMapPoint(previousPoint)
            self.transform = CGAffineTransform(rotationAngle: getHeadingForDirectionFromCoordinate(pPoint.coordinate, toCoordinate: mapPoint.coordinate))
        }
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "position")
        animation.fromValue = NSValue(cgPoint: self.center)
        animation.toValue = NSValue(cgPoint: toPos)
        animation.duration = 1.0
        animation.delegate = self
        animation.fillMode = CAMediaTimingFillMode.forwards
        //[self.layer removeAllAnimations];
        self.layer.add(animation, forKey: "positionAnimation")
        
        if self.mapView!.visibleMapRect.contains(mapPoint) {
            
            //NSLog(@"setPosition ANIMATED %x from (%f, %f) to (%f, %f)", self, self.center.x, self.center.y, toPos.x, toPos.y);
        }
        self.center = toPos
        (self.annotation as! LetsAnnotation).coordinate = posValue
        previousPoint = posValue
    }
    
    
}
func getHeadingForDirectionFromCoordinate(_ fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> CGFloat {
    let fLat: Float = degreesToRadians(fromLoc.latitude)
    let fLng: Float = degreesToRadians(fromLoc.longitude)
    let tLat: Float = degreesToRadians(toLoc.latitude)
    let tLng: Float = degreesToRadians(toLoc.longitude)
    let degree: Float = atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))
    let deg: Float = radiandsToDegrees(Double(degree))
    return CGFloat(degreesToRadians(Double(deg)))
}
func degreesToRadians(_ x : Double) -> Float{
    return Float(Double.pi * x / 180.0)
}
func radiandsToDegrees(_ x : Double) -> Float{
    return Float(x * 180.0 / Double.pi)
}

//
//  MapManager.swift
//
//
//  Created by Jimmy Jose on 14/08/14.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import CoreLocation
import MapKit


typealias DirectionsCompletionHandler = ((_ route:MKPolyline?, _ directionInformation:NSDictionary?, _ boundingRegion:MKMapRect?, _ error:String?)->())?

// TODO: Documentation

class MapManager: NSObject{
    
    
    private var directionsCompletionHandler:DirectionsCompletionHandler = nil
    private let errorNoRoutesAvailable = "No routes available"// add more error handling
    
    private let errorDictionary = ["NOT_FOUND" : "At least one of the locations specified in the request's origin, destination, or waypoints could not be geocoded",
                                   "ZERO_RESULTS":"No route could be found between the origin and destination",
                                   "MAX_WAYPOINTS_EXCEEDED":"Too many waypointss were provided in the request The maximum allowed waypoints is 8, plus the origin, and destination",
                                   "INVALID_REQUEST":"The provided request was invalid. Common causes of this status include an invalid parameter or parameter value",
                                   "OVER_QUERY_LIMIT":"Service has received too many requests from your application within the allowed time period",
                                   "REQUEST_DENIED":"Service denied use of the directions service by your application",
                                   "UNKNOWN_ERROR":"Directions request could not be processed due to a server error. Please try again"]
    
    
    
    func directions(from:CLLocationCoordinate2D,to:NSString,directionCompletionHandler:DirectionsCompletionHandler){
        
        self.directionsCompletionHandler = directionCompletionHandler
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(to as String, completionHandler: { (placemarksObject, error) -> Void in
            
            if(error != nil){
                
                self.directionsCompletionHandler!(nil,nil, nil, error!.localizedDescription)
                
            }else{
                
                let placemarks = placemarksObject! as NSArray
                let placemark = placemarks.lastObject as! CLPlacemark
                let placemarkSource = MKPlacemark(coordinate: from, addressDictionary: nil)
                let source = MKMapItem(placemark: placemarkSource)
                let placemarkDestination = MKPlacemark(placemark: placemark)
                let destination = MKMapItem(placemark: placemarkDestination)
                
                self.directionsFor(source: source, destination: destination, directionCompletionHandler: directionCompletionHandler)
                
            }
        })
    }
    
    
    func directionsFromCurrentLocation(to:NSString,directionCompletionHandler:DirectionsCompletionHandler){
        
        self.directionsCompletionHandler = directionCompletionHandler
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(to as String, completionHandler: { (placemarksObject, error) -> Void in
            
            if(error != nil){
                
                self.directionsCompletionHandler!(nil,nil, nil, error!.localizedDescription)
                
            }else{
                
                let placemarks = placemarksObject! as NSArray
                let placemark = placemarks.lastObject as! CLPlacemark
                
                let source = MKMapItem.forCurrentLocation()
                
                let placemarkDestination = MKPlacemark(placemark: placemark)
                let destination = MKMapItem(placemark: placemarkDestination)
                
                self.directionsFor(source: source, destination: destination, directionCompletionHandler: directionCompletionHandler)
                
                
            }
        })
        
    }
    
    
    func directionsFromCurrentLocation(to:CLLocationCoordinate2D,directionCompletionHandler:DirectionsCompletionHandler){
        
        //let directionRequest = MKDirectionsRequest()
        
        let source = MKMapItem.forCurrentLocation()
        let placemarkDestination = MKPlacemark(coordinate: to, addressDictionary: nil)
        
        let destination = MKMapItem(placemark: placemarkDestination)
        
        directionsFor(source: source, destination: destination, directionCompletionHandler: directionCompletionHandler)
        
    }
    
    func directions(from:CLLocationCoordinate2D, to:CLLocationCoordinate2D,directionCompletionHandler:DirectionsCompletionHandler){
        
        //var directionRequest = MKDirectionsRequest()
        let placemarkSource = MKPlacemark(coordinate: from, addressDictionary: nil)
        let source = MKMapItem(placemark: placemarkSource)
        let placemarkDestination = MKPlacemark(coordinate: to, addressDictionary: nil)
        
        let destination = MKMapItem(placemark: placemarkDestination)
        
        directionsFor(source: source, destination: destination, directionCompletionHandler: directionCompletionHandler)
        
    }
    
    private func directionsFor(source:MKMapItem, destination:MKMapItem,directionCompletionHandler:DirectionsCompletionHandler){
        
        self.directionsCompletionHandler = directionCompletionHandler
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = source
        directionRequest.destination = destination
        directionRequest.transportType = MKDirectionsTransportType.any
        directionRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate{
            response, error in
            
            guard let response = response else {
                //handle the error here
                return
            }
            
            if (error != nil) {
                self.directionsCompletionHandler!(nil,nil, nil, error!.localizedDescription)
            }else if(response.routes.isEmpty){
                
                self.directionsCompletionHandler!(nil,nil, nil, self.errorNoRoutesAvailable)
            }else{
                
                let route: MKRoute = response.routes[0]
                let steps = route.steps as NSArray
                //let stop = false
                let end_address = route.name
                let distance = route.distance.description
                let duration = route.expectedTravelTime.description
                
                let source = response.source.placemark.coordinate
                let destination = response.destination.placemark.coordinate
                
                let start_location = ["lat":source.latitude,"lng":source.longitude]
                let end_location = ["lat":destination.latitude,"lng":destination.longitude]
                
                let stepsFinalArray = NSMutableArray()
                
                steps.enumerateObjects({ (obj, idx, stop) -> Void in
                    
                    let step:MKRoute.Step = obj as! MKRoute.Step
                    
                    let distance = step.distance.description
                    
                    let instructions = step.instructions
                    
                    let stepsDictionary = NSMutableDictionary()
                    
                    stepsDictionary.setObject(distance, forKey: "distance" as NSCopying)
                    stepsDictionary.setObject("", forKey: "duration" as NSCopying)
                    stepsDictionary.setObject(instructions, forKey: "instructions" as NSCopying)
                    
                    
                    stepsFinalArray.add(stepsDictionary)
                    
                })
                
                let stepsDict = NSMutableDictionary()
                stepsDict.setObject(distance, forKey: "distance" as NSCopying)
                stepsDict.setObject(duration, forKey: "duration" as NSCopying)
                stepsDict.setObject(end_address, forKey: "end_address" as NSCopying)
                stepsDict.setObject(end_location, forKey: "end_location" as NSCopying)
                stepsDict.setObject("", forKey: "start_address" as NSCopying)
                stepsDict.setObject(start_location, forKey: "start_location" as NSCopying)
                stepsDict.setObject(stepsFinalArray, forKey: "steps" as NSCopying)
                
                
                self.directionsCompletionHandler!(route.polyline,stepsDict, route.polyline.boundingMapRect,
                                                  
                                                  nil)
            }
        }
    }
    
    /**
     Get directions using Google API by passing source and destination as string.
     
     - parameter from: Starting point of journey
     - parameter to: Ending point of journey
     - returns: directionCompletionHandler: Completion handler contains polyline,dictionary,maprect and error
     
     */
    
    func directionsUsingGoogle(from:NSString, to:NSString,directionCompletionHandler:DirectionsCompletionHandler){
        
        getDirectionsUsingGoogle(origin: from, destination: to, directionCompletionHandler: directionCompletionHandler)
        
    }
    
    func directionsUsingGoogle(from:CLLocationCoordinate2D, to:CLLocationCoordinate2D,directionCompletionHandler:DirectionsCompletionHandler){
        
        let originLatLng = "\(from.latitude),\(from.longitude)"
        let destinationLatLng = "\(to.latitude),\(to.longitude)"
        
        getDirectionsUsingGoogle(origin: originLatLng as NSString, destination: destinationLatLng as NSString, directionCompletionHandler: directionCompletionHandler)
        
    }
    
    func directionsUsingGoogle(from:CLLocationCoordinate2D, to:NSString,directionCompletionHandler:DirectionsCompletionHandler){
        
        let originLatLng = "\(from.latitude),\(from.longitude)"
        
        getDirectionsUsingGoogle(origin: originLatLng as NSString, destination: to, directionCompletionHandler: directionCompletionHandler)
        
    }
    
    private func getDirectionsUsingGoogle(origin:NSString, destination:NSString,directionCompletionHandler:DirectionsCompletionHandler){
        
        self.directionsCompletionHandler = directionCompletionHandler
        
        let path = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.folding(options: NSString.CompareOptions.diacriticInsensitive, locale: nil).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&destination=\(destination.folding(options: NSString.CompareOptions.diacriticInsensitive, locale: nil).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&key=\(GooglePlaceKey)"
        performOperationForURL(urlString: path)
        
    }
    
    
    private func performOperationForURL(urlString:String){
        print(urlString)
        let url:URL? = URL(string:urlString)
        let request:URLRequest = URLRequest(url:url!)
        
        
        let queue:OperationQueue = OperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest,queue:queue,completionHandler:{response,data,error in
            
            if(error != nil){
                
                print(error!.localizedDescription)
                
                self.directionsCompletionHandler!(nil,nil, nil, error!.localizedDescription)
                
                
            }else{
                
                //  let dataAsString: NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
                
                //var err: NSError
                let jsonResult: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                
                let routes = jsonResult.object(forKey: "routes") as! NSArray
                let status = jsonResult.object(forKey: "status") as! NSString
                if routes.count>0 {
                    
                    let route = routes.lastObject as! NSDictionary //first object?
                    
                    if(status.isEqual(to: "OK") && route.allKeys.count>0){
                        
                        let legs = route.object(forKey: "legs") as! NSArray
                        let steps = legs.firstObject as! NSDictionary
                        let directionInformation = self.parser(data: steps) as NSDictionary
                        let overviewPolyline = route.object(forKey: "overview_polyline") as! NSDictionary
                        let points = overviewPolyline.object(forKey: "points") as! NSString
                        
                        let locations = self.decodePolyLine(encodedStr: points) as Array
                        
                        var coordinates = locations.map({ (location: CLLocation) ->
                            CLLocationCoordinate2D in
                            return location.coordinate
                        })
                        
                        print("=====&coordinates===\(coordinates)====locations.count===\(locations.count)")
                        
                        let polyline = MKPolyline(coordinates: &coordinates,
                                                  count: locations.count)
                        
                        self.directionsCompletionHandler!(polyline,directionInformation, polyline.boundingMapRect, nil)
                        
                    }else{
                        
                        var errorMsg = self.errorDictionary[status as String]
                        
                        if(errorMsg == nil){
                            
                            errorMsg = self.errorNoRoutesAvailable
                        }
                        
                        self.directionsCompletionHandler!(nil,nil, nil, errorMsg)
                        
                    }
                }else{
                    
                    var errorMsg = self.errorDictionary[status as String]
                    
                    if(errorMsg == nil){
                        
                        errorMsg = self.errorNoRoutesAvailable
                    }
                    
                    self.directionsCompletionHandler!(nil,nil, nil, errorMsg)
                }
            }
        }
        )
        
    }
    
    
    
    private func decodePolyLine(encodedStr:NSString)->Array<CLLocation>{
        
        /*    var array = Array<CLLocation>()
         let len = encodedStr.length
         let range = NSMakeRange(0, len)
         var strpolyline = encodedStr
         let index = 0
         var lat :UInt = 0
         var lng :UInt = 0
         
         strpolyline = encodedStr.replacingOccurrences(of: "\\\\", with: "\\", options: NSString.CompareOptions.literal, range: range) as NSString
         
         
         while(index<len){
         
         var b = 0
         var shift :UInt = 0
         var result :UInt = 0
         
         repeat{
         let numUnichar = strpolyline.character(at: index+1)
         let num =  NSNumber(value: numUnichar)
         let numInt = num.intValue
         b = numInt - 63
         print("=b==\(b)===shift====\(shift)")
         print("=UInt32==\(Int((b & 0x1f)))===shift====\(shift)===result==\(result)")
         result |= UInt((b & 0x1f)) << shift
         shift += 5
         }while(b >= 0x20)
         
         var dlat :UInt = 0
         
         if((result & 1) == 1){
         
         dlat = ~(result >> 1)
         }else{
         
         dlat = (result >> 1)
         }
         
         lat += dlat
         
         shift = 0
         result = 0
         
         repeat{
         let numUnichar = strpolyline.character(at: index+1)
         let num =  NSNumber(value: numUnichar)
         let numInt = num.intValue
         b = numInt - 63
         
         result |= UInt((b & 0x1f)) << shift
         shift += 5
         
         }while(b >= 0x20)
         
         var dlng : UInt = 0
         
         if((result & 1) == 1){
         
         dlng = ~(result >> 1)
         }else{
         
         dlng = (result >> 1)
         
         }
         lng += dlng
         
         
         let latitude = NSNumber(value:lat).doubleValue * 1e-5
         let longitude = NSNumber(value:lng).doubleValue * 1e-5
         
         let location = CLLocation(latitude: latitude, longitude: longitude)
         
         array.append(location)
         
         }
         
         return array
         
         */
        
        // var myRoutePoints=[CLLocationCoordinate2D]()
        var array = Array<CLLocation>()
        let bytes = (encodedStr as NSString).utf8String
        var idx: Int = 0
        var latitude: Double = 0
        var longitude: Double = 0
        while (idx < encodedStr.lengthOfBytes(using: String.Encoding.utf8.rawValue)) {
            var byte = 0
            var res = 0
            var shift = 0
            repeat {
                byte = Int(bytes![idx] - 63)
                idx += 1
                res |= (byte & 0x1F) << shift
                shift += 5
            } while (byte >= 0x20)
            let deltaLat = ((res & 1) != 0x0 ? ~(res >> 1) : (res >> 1))
            latitude += Double(deltaLat)
            
            shift = 0
            res = 0
            repeat {
                byte = Int(bytes![idx] - 63)
                idx += 1
                res |= (byte & 0x1F) << shift
                shift += 5
            } while (byte >= 0x20)
            let deltaLon = ((res & 1) != 0x0 ? ~(res >> 1) : (res >> 1))
            longitude += Double(deltaLon)
            
            // myRoutePoints.append(CLLocation(latitude: Double(latitude * 1E-5), longitude: Double(longitude * 1E-5)).coordinate)
            
            let latitude = NSNumber(value:latitude).doubleValue * 1e-5
            let longitude = NSNumber(value:longitude).doubleValue * 1e-5
            
            let location = CLLocation(latitude: latitude, longitude: longitude)
            
            array.append(location)
        }
        return array
        
    }
    
    private func parser(data:NSDictionary)->NSDictionary{
        
        // var dict = NSMutableDictionary()
        let distance = (data.object(forKey: "distance") as! NSDictionary).object(forKey: "text") as! NSString
        
        let duration = (data.object(forKey: "duration") as! NSDictionary).object(forKey: "text") as! NSString
        
        let end_address = data.object(forKey: "end_address") as! NSString
        let end_location = data.object(forKey: "end_location") as! NSDictionary
        let start_address = data.object(forKey: "start_address") as! NSString
        let start_location = data.object(forKey: "start_location") as! NSDictionary
        let stepsArray = data.object(forKey: "steps") as! NSArray
        
        let stepsDict = NSMutableDictionary()
        //  var stop = false
        
        let stepsFinalArray = NSMutableArray()
        
        stepsArray.enumerateObjects({ (obj, idx, stop) -> Void in
            
            let stepDict = obj as! NSDictionary
            
            let distance = (stepDict.object(forKey: "distance") as! NSDictionary).object(forKey: "text") as! NSString
            
            let duration = (stepDict.object(forKey: "duration") as! NSDictionary).object(forKey: "text") as! NSString
            let html_instructions = stepDict.object(forKey: "html_instructions") as! NSString
            let end_location = stepDict.object(forKey: "end_location") as! NSDictionary
            let instructions = self.removeHTMLTags(source: (stepDict.object(forKey: "html_instructions") as! NSString))
            let start_location = stepDict.object(forKey: "start_location") as! NSDictionary
            
            let stepsDictionary = NSMutableDictionary()
            
            stepsDictionary.setObject(distance, forKey: "distance" as NSCopying)
            stepsDictionary.setObject(duration, forKey: "duration" as NSCopying)
            stepsDictionary.setObject(html_instructions, forKey: "html_instructions" as NSCopying)
            stepsDictionary.setObject(end_location, forKey: "end_location" as NSCopying)
            stepsDictionary.setObject(instructions, forKey: "instructions" as NSCopying)
            stepsDictionary.setObject(start_location, forKey: "start_location" as NSCopying)
            
            stepsFinalArray.add(stepsDictionary)
            
            
        })
        
        stepsDict.setObject(distance, forKey: "distance" as NSCopying)
        stepsDict.setObject(duration, forKey: "duration" as NSCopying)
        stepsDict.setObject(end_address, forKey: "end_address" as NSCopying)
        stepsDict.setObject(end_location, forKey: "end_location" as NSCopying)
        stepsDict.setObject(start_address, forKey: "start_address" as NSCopying)
        stepsDict.setObject(start_location, forKey: "start_location" as NSCopying)
        stepsDict.setObject(stepsFinalArray, forKey: "steps" as NSCopying)
        
        
        return stepsDict
        
    }
    
    private func removeHTMLTags(source:NSString)->NSString{
        
        var range = NSMakeRange(0, 0)
        let HTMLTags = "<[^>]*>"
        
        var sourceString = source
        while( sourceString.range(of: HTMLTags, options: NSString.CompareOptions.regularExpression).location != NSNotFound){
            
            range = sourceString.range(of: HTMLTags, options: NSString.CompareOptions.regularExpression)
            
            sourceString = sourceString.replacingCharacters(in: range, with: "") as NSString
        }
        
        
        return sourceString;
        
    }
    
}


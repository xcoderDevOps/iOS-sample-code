//
//  MyPlaceListVC.swift
//  CargoXpress
//
//  Created by Alpesh Desai on 13/01/21.
//  Copyright © 2021 Rushkar. All rights reserved.
//

import UIKit
import GooglePlaces

class MyPlaceListCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    var blockDelete: (()->())?
    @IBAction func deleteAddressCLK(_ sender:UIButton) {
        if blockDelete != nil {
            blockDelete!()
        }
    }
}

class MyPlaceListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    private var placesClient: GMSPlacesClient!
    
    var placeArray = [MyPlaceData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftDriverMenuButton()
        title = "My Places"
        placesClient = GMSPlacesClient.shared()
        lblTitle.isHidden = true
        callGetPlaceList { (data) in
            self.lblTitle.isHidden = data.isEmpty
            self.placeArray = data
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }

    
    @IBAction func btnAddNewAddressCLK(_ sender:UIButton) {
        _ = displayViewController(SLpopupViewAnimationType.topBottom, nibName: "PopupSearchLocationVC", blockOK: { (address) in
            appDelegate.window?.rootViewController?.dismissPopupViewController(.bottomTop)
            if let arr = address as? [String], let id = arr.first, let str = arr.last {
                let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.coordinate.rawValue))!
                self.placesClient?.fetchPlace(fromPlaceID: id, placeFields: fields, sessionToken: nil, callback: { (place1: GMSPlace?, error: Error?) in
                  if let error = error {
                    print("An error occurred: \(error.localizedDescription)")
                    return
                  }
                    
                  if let place1 = place1 {
                        let param = ["Name":str,
                                     "Lat":"\(place1.coordinate.latitude)",
                                     "Long":"\(place1.coordinate.longitude)",
                                     "CarrierId":UserInfo.savedUser()!.Id] as [String : Any]
                    self.callAddNewPlace(param) { (data) in
                        if let data = data {
                            self.placeArray.append(data)
                            self.tableView.reloadData()
                        }
                    }
                  }
                })
            }
            
        }, blockCancel: {
            appDelegate.window?.rootViewController?.dismissPopupViewController(.bottomTop)
        }, objData: nil)
    }
    
}

extension MyPlaceListVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPlaceListCell") as! MyPlaceListCell
        let obj = self.placeArray[indexPath.row]
        cell.lblTitle.text = obj.Name
        cell.blockDelete = { () -> Void in
            self.callDeletePlaceData(id: "\(self.placeArray[indexPath.row].Id)") { (str) in
                if str == "200" {
                    self.placeArray.remove(at: indexPath.row)
                    tableView.reloadData()
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

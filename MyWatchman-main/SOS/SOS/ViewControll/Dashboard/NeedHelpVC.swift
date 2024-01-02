//
//  NeedHelpVC.swift
//  SOS
//
//  Created by Alpesh Desai on 09/07/21.
//

import UIKit
import GooglePlaces
import Kingfisher


class NeedHelpCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    func aweakFromNib() {
        super.awakeFromNib()
    }
}

class NeedHelpVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var xAxhis: NSLayoutConstraint!
    @IBOutlet weak var btnMe: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    
    @IBOutlet weak var lblBottomText: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    
    var sosData : SOSHistoryData?
    var location : CLLocation?
    
    static var sosTypes = [SOSTypeData]()
    
    static var arrayAddress = [AddressListData]()
    var flagOpnSos = true
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnMe.isSelected = true
        viewBottom.isHidden = true
        callGetSosList { (data) in
            NeedHelpVC.sosTypes = data
            self.collectionView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCurrentLocation()
        self.callGetRaisedSOS()
        self.callAddressAPI()
        
        dashTabVC?.title = "Need Help"
        
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 12.0, target: self, selector: #selector(callGetRaisedSOS), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    @objc func callGetRaisedSOS() {
        callGetRaiseSOS(id: UserInfo.savedUser()!.Id) { (data) in
            if let data = data {
                self.sosData = data
                if data.Status == 1 {
                    self.viewBottom.isHidden = false
                    self.lblBottomText.text = "You have one ongoing SOS. click view to see details"
                } else if data.Status == 2 {
                    self.lblBottomText.text = "You have one pending SOS completion request"
                    self.viewBottom.isHidden = false
                } else {
                    self.viewBottom.isHidden = true
                }
            } else {
                self.viewBottom.isHidden = true
            }
        }
    }
    
    func callAddressAPI() {
        callGetAddressList { (data) in
            NeedHelpVC.arrayAddress = data
        }
    }
    
    func getCurrentLocation() {
        appDelegate.setupLocationManager() { (loc) in
            self.location = CLLocation(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
        }
    }
    
    @IBAction func btnViewSosClk(_ sender: UIButton) {
        if let sos = self.sosData {
            if sos.Status == 1 {
                let controll = MainBoard.instantiateViewController(identifier: "SOSDetailVC") as! SOSDetailVC
                controll.sosId = sos.Id
                self.navigationController?.pushViewController(controll, animated: true)
            } else if sos.Status == 2 {
                let controll = MainBoard.instantiateViewController(identifier: "SurveyTaskVC") as! SurveyTaskVC
                controll.sosId = sos.Id
                controll.completionBLK = { () -> Void in
                    self.viewBottom.isHidden = true
                    self.callGetRaisedSOS()
                }
                self.navigationController?.pushViewController(controll, animated: true)
            }
        }
    }
    
    @IBAction func tapToClickOnTap(_ sender: UIButton) {
        xAxhis.constant = sender.frame.origin.x
        btnMe.isSelected = false
        btnOther.isSelected = false
        sender.isSelected = true
        UIView.animate(withDuration: 0.33) {
            self.view.layoutIfNeeded()
        }
    }
    
    func openRaiseSosView(index:Int) {
        if !flagOpnSos {
            return
        }
        flagOpnSos = false
        
        if self.btnMe.isSelected {
            _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupSosRaiseView", blockOK: { (obj) in
                guard let loc = self.location else {
                    return
                }
                
                let param = [   "CustomerId":UserInfo.savedUser()!.Id,
                                "Latitude":loc.coordinate.latitude,
                                "Longitude":loc.coordinate.longitude,
                                "SOSTypeId":NeedHelpVC.sosTypes[index].Id] as [String : Any]
                
                self.callPostRaiseSOS(param: param) { (data) in
                    if data != nil {
                        self.callGetRaisedSOS()
                    }
                }
                dismissPopUp()
                self.flagOpnSos = true
            }, blockCancel: {
                dismissPopUp()
                self.flagOpnSos = true
            }, objData: nil)
            
        } else {
            if NeedHelpVC.arrayAddress.isEmpty {
                showAlert("Please Add Address from Address Tab")
                return
            }
            _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupAddressSOSRaiseView", blockOK: { (obj) in
                if let index = obj as? Int {
                    let param = [   "CustomerId":UserInfo.savedUser()!.Id,
                                    "AddressId": NeedHelpVC.arrayAddress[index].Id ,
                                    "SOSTypeId":NeedHelpVC.sosTypes[index].Id] as [String : Any]
                    
                    self.callPostRaiseSOS(param: param) { (data) in
                        if data != nil {
                            self.callGetRaisedSOS()
                        }
                    }
                }
                dismissPopUp()
                self.flagOpnSos = true
            }, blockCancel: {
                dismissPopUp()
                self.flagOpnSos = true
            }, objData: nil)
        }
    }
}

extension NeedHelpVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NeedHelpVC.sosTypes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NeedHelpCell", for: indexPath) as! NeedHelpCell
        let obj = NeedHelpVC.sosTypes[indexPath.row]
        //cell.imgView.image =
        if let str = obj.ImageUrlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: str) {
            let source = ImageResource(downloadURL: url)
            cell.imgView.kf.setImage(with: source)
        }
        cell.lblTitle.text = obj.ShortName
        //cell.imgView.backgroundColor = arrayColor[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openRaiseSosView(index: indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (UIScreen.width-24)/3 - 6
        return CGSize(width: size, height: size)
    }
}

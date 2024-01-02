//
//  AddressDetailVC.swift
//  SOS
//
//  Created by Alpesh Desai on 29/12/20.
//

import UIKit
import Kingfisher

class SOSRaisedCell : UITableViewCell {
    @IBOutlet weak var lblRaisedOn: UILabel!
    @IBOutlet weak var lblHelpReach: UILabel!
    @IBOutlet weak var lblRoaming: UILabel!
    @IBOutlet weak var lblSosType: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
}

class AddressDetailVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var addressData = AddressListData()
    var arrayData = [SOSHistoryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        title = "Address Detail"
        let url = baseURL + URLS.SOSByAddresIdCustomerId.rawValue + "CustomerId=\(UserInfo.savedUser()!.Id)&AddressId=\(addressData.Id)&Offset=0&Limit=10000"
        lblTitle.text = addressData.AddressName
        lblSubTitle.text = addressData.Address
        callGetSOSList(url: url) { (data) in
            self.arrayData = data
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }

}

extension AddressDetailVC : UITableViewDelegate,  UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SOSRaisedCell") as! SOSRaisedCell
        let obj = self.arrayData[indexPath.row]
        cell.imgView.image = UIImage(named: "fire")
        cell.lblSosType.text = obj.SOSType.isEmpty ? "-" : "\(obj.SOSType)"
        cell.lblRoaming.text = "\(obj.RoamingStaffName)"
        cell.lblRaisedOn.text = "\(obj.StartDate) \(obj.StartTime)"
        cell.lblHelpReach.text = obj.CompletedSOSInMin.isEmpty ? "-" : "\(obj.CompletedSOSInMin) minutes"
        if let str = obj.SOSTypeImageUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: str) {
            let source = ImageResource(downloadURL: url)
            cell.imgView.kf.setImage(with: source)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controll = MainBoard.instantiateViewController(identifier: "SOSRatingDetailPageVC") as! SOSRatingDetailPageVC
        controll.sosHistoryData = self.arrayData[indexPath.row]
        self.navigationController?.pushViewController(controll, animated: true)
    }
}



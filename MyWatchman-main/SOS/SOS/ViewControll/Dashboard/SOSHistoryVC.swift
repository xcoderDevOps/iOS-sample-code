//
//  SOSHistoryVC.swift
//  SOS
//
//  Created by Alpesh Desai on 28/12/20.
//

import UIKit
import Kingfisher

class SOSHistoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var arrayData = [SOSHistoryData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftMenuButton()
        callGetSOSList() { (data) in
            self.arrayData = data
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dashTabVC?.title = "SOS History"
    }
}

extension SOSHistoryVC : UITableViewDelegate,  UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SOSRaisedCell") as! SOSRaisedCell
        let obj = self.arrayData[indexPath.row]
        cell.lblRaisedOn.text =  "\(obj.StartDate), \(obj.StartTime)"
        cell.lblHelpReach.text = "\(obj.EndDate), \(obj.EndTime)"
        cell.lblRoaming.text = obj.RoamingStaffName.isEmpty ? "-" : obj.RoamingStaffName
        cell.lblSosType.text = obj.SOSTypeShortName
        cell.lblLocation.text = obj.AddressName.isEmpty ? "Current Location" : obj.AddressName
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

//
//  BidHistoryVC.swift
//  CargoXpress
//
//  Created by infolabh on 08/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class BidHistoryCell : UITableViewCell
{
    //MARK: - Variable declaration -
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPickUp: UILabel!
    @IBOutlet weak var lblDrop: UILabel!
    
    var blockDateClicked : (() -> ())?
    
    @IBAction func btnDateClicked(_ sender: UIButton) {
        if blockDateClicked != nil
        {
            blockDateClicked!()
        }
    }
}

class BidHistoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var jobList = [JobData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftDriverMenuButton()
        jobListAPI()
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func jobListAPI() {
        let url = baseURL + URLS.Job_All.rawValue + "CarrierId=\(UserInfo.savedUser()!.Id)&JobStatus=Job%20completed"
        callGetAlljobList(url: url, flag: true) { (data) in
            self.jobList.removeAll()
            if let data = data {
                self.jobList = data
            } else {
                showAlert("No Jobs Found")
            }
            self.tableView.reloadData()
        }
    }

}

extension BidHistoryVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BidHistoryCell") as! BidHistoryCell
        if (indexPath.row % 2) == 0 {
            cell.contentView.backgroundColor = UIColor.white
        } else {
            cell.contentView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        }
        let obj = jobList[indexPath.row]
        cell.lblDate.text = obj.PickupDate
        cell.lblPickUp.text = obj.PickUpAddress
        cell.lblDrop.text = obj.DropOffAddress
        cell.blockDateClicked = {() -> Void in
            self.callGetRootData(jobId: "\(obj.Id)") { (data) in
                
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
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupJobInfoVC", blockOK: { (obj) in
            dismissPopUp()
        }, blockCancel: {
            dismissPopUp()
        }, objData: jobList[indexPath.row] as AnyObject)
    }
    
}

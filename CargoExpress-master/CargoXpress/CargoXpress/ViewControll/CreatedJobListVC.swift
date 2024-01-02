//
//  CreatedJobListVC.swift
//  GoldClean
//
//  Created by infolabh on 25/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class CreatedJobList : UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
}

class CreatedJobListVC: UITableViewController {

    var jobList = [JobData]()
    
    var completionBlock:((_ jobData : JobData)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        
        let url = baseURL + URLS.Job_All.rawValue + (appDelegate.isFindService ? "ShipperId=\(UserInfo.savedUser()!.Id)" : "CarrierId=\(UserInfo.savedUser()!.Id)")
        callGetAlljobList(url: url, flag: true) { (data) in
            self.jobList.removeAll()
            if let data = data {
                self.jobList = data
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
            } else {
                showAlert("No Jobs Found")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jobList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreatedJobList") as! CreatedJobList
        let obj = jobList[indexPath.row]
        cell.lblTitle.text = obj.JobNo
        cell.lblSubTitle.text = "Date: \(obj.PickupDate)"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if completionBlock != nil {
            completionBlock!(jobList[indexPath.row])
            self.dismiss(animated: true, completion: nil)
        }
    }
}

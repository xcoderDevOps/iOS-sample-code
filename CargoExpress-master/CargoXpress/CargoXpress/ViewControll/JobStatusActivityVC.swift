//
//  JobStatusActivityVC.swift
//  CargoXpress
//
//  Created by infolabh on 30/06/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class JobStatusActivityCell : UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var bottom: NSLayoutConstraint!
    @IBOutlet weak var centerView: LetsView!
}

class JobStatusActivityVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var jobId = ""
    var activitys = [JobStatusActivityData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton(color: UIColor.white)
        
        self.callGetJobActivityData(jobId: jobId) { (data) in
            self.activitys = data
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
}

extension JobStatusActivityVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitys.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobStatusActivityCell") as! JobStatusActivityCell
        let obj = activitys[indexPath.row]
        cell.lblTitle.text = obj.CurrentJobStatus
        cell.lblSubTitle.text = obj.CreatedDateStr
        if indexPath.row == 0 {
            cell.top.constant = cell.centerView.frame.origin.y + 5
            cell.bottom.constant = 0.0
        } else if indexPath.row == activitys.count-1 {
            cell.top.constant = 0.0
            cell.bottom.constant = cell.centerView.frame.origin.y + 5
        } else  {
            cell.top.constant = 0.0
            cell.bottom.constant = 0.0
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

//
//  NotificationListVC.swift
//  NewsPaper
//
//  Created by Alpesh Desai on 09/12/21.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewDot: UIView!
}

class NotificationListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var notificationList = [NotificationDataList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let info = UserInfo.savedUser() else {
            return
        }
        let url = baseURL + URLS.UserNotifications_All.rawValue + "\(info.Id)"
        
        let param = [   "Offset": 0,
                        "Limit": 0,
                        "IsOffsetProvided": true,
                        "Page": 0,
                        "PageSize": 0,
                        "SortBy": "string",
                        "TotalCount": 0,
                        "SortDirection": "string",
                        "IsPageProvided": true
                    ] as [String : Any]
        
        callGetnotificationData(url, param: param) { data in
            self.notificationList = data
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }

}

extension NotificationListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        let obj = self.notificationList[indexPath.row]
        cell.lblTitle.text = obj.NotificationText
        cell.viewDot.isHidden = obj.IsRead
        cell.lblDate.text = obj.CreatedDateStr
        return cell
    }
}

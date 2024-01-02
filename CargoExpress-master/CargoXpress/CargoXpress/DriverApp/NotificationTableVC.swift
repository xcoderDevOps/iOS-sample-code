//
//  NotificationTableVC.swift
//  CargoXpress
//
//  Created by Alpesh Desai on 28/09/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class NotificationTableVC: UITableViewController {

    var arrNotification  = [NotificationData]()
    var notificationHeaderView : NotificationHeaderView!
    var selectedData = MyPlaceData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notification"
        backButton(color: UIColor.white)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        
        tableView.separatorStyle = .none
        
        
        
        callGetNotificationCount(url: baseURL+URLS.Notification_IsReadUpdate.rawValue) { (item) in
        }
        self.getGeneralNotification()
        if !appDelegate.isFindService {
            notificationHeaderView = NotificationHeaderView.fromNib()
            notificationHeaderView.setupCollectionView(selected: selectedData, { (data) in
                self.selectedData = data
                if self.selectedData.Id == 0 {
                    self.getGeneralNotification()
                } else {
                    self.getNotificationByPlaceId(id: self.selectedData.Id)
                }
            })
            tableView.tableHeaderView = notificationHeaderView
        }
        self.tableView.backgroundColor = UIColor.bgColor()
    }

    func getGeneralNotification() {
        let url = baseURL+URLS.Notification_All.rawValue+"\(UserInfo.savedUser()!.Id)"
        callGetNotification(url: url) { (data) in
            self.arrNotification = data
            self.tableView.reloadData()
            if !data.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.separatorStyle = .singleLine
                }
            }
        }
    }
    
    func getNotificationByPlaceId(id:Int) {
        let url = baseURL+URLS.NotificationByPlaceId.rawValue+"\(id)"
        callGetNotification(url: url) { (data) in
            self.arrNotification = data
            self.tableView.reloadData()
            if !data.isEmpty {
                DispatchQueue.main.async {
                    self.tableView.separatorStyle = .singleLine
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let headerView = tableView.tableHeaderView {

            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
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
        return self.arrNotification.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.lblDate.text = self.arrNotification[indexPath.row].CreatedDateStr
        cell.lblTitle.text = self.arrNotification[indexPath.row].Text
        cell.selectionStyle = .none
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

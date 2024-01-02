//
//  MyBalanceVC.swift
//  GoldClean
//
//  Created by infolabh on 10/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit


class MyBalanceVC: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Earnings"
        leftDriverMenuButton()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTransactionCell") as! MyTransactionCell
        //cell.lblTitle.text = ""
//        cell.lblSubTitle.text = "Time: 09:00 AM"
//        cell.lblDate.text = "14\nApril"
//        cell.lblAmount.text = "25$"
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.openPopupAtIndex(index: indexPath.row)
    }

    func openPopupAtIndex(index: Int) {
        _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupJobInfoVC", blockOK: { (obj) in
                       dismissPopUp()
                   }, blockCancel: {
                       dismissPopUp()
                   }, objData: nil)
    }
    
}

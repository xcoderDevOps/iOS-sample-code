//
//  MyTransactionVC.swift
//  GoldClean
//
//  Created by infolabh on 18/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class MyTransactionCell : UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
}

class MyTransactionVC: UIViewController {

    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leftMenuButton()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapToChangeSegment(_ sender: Any) {
        self.tableView.reloadData()
    }

}
extension MyTransactionVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTransactionCell") as! MyTransactionCell
        cell.lblTitle.text = "House Cleaning, Lease Cleaning"
        cell.lblSubTitle.text = "04 March 2020 at 09:00 AM"
        cell.lblDate.text = "14\nApril"
        cell.lblAmount.text = "25$"
        
        if segmentView.selectedSegmentIndex == 0 {
            cell.lblAmount.textColor = UIColor.green
        } else {
            cell.lblAmount.textColor = UIColor.red
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136.0
    }
}


//
//  HelpAndSupportListVC.swift
//  NewsPaper
//
//  Created by Alpesh Desai on 18/01/22.
//

import UIKit

class HelpAndSupportCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
}

class HelpAndSupportListVC: UITableViewController {

    var arrayList = ["Privacy Policy", "Refund & Cancellation Policy", "Usage"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func tapOnCallCLK(_ sender: UIButton) {
        if let url = URL(string: "tel://+919825012910"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func tapOnMailCLK(_ sender: UIButton) {
        let email = "info@capitalworldguj.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
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
        return arrayList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HelpAndSupportCell", for: indexPath) as! HelpAndSupportCell
        cell.lblTitle.text = arrayList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let controll = MainBoard.instantiateViewController(withIdentifier: "HelpDetailVC") as! HelpDetailVC
        controll.titleLabel = arrayList[indexPath.row]
        switch arrayList[indexPath.row] {
        case "Privacy Policy":
            controll.link = "http://capitalworldguj.com/privacy-policy.html"
        case "Refund & Cancellation Policy":
            controll.link = "http://capitalworldguj.com/refund-policy.html"
        case "Usage":
            controll.link = "http://capitalworldguj.com/contact-us.html"
        default:
            break
        }
        controll.titleLabel = arrayList[indexPath.row]
        self.navigationController?.pushViewController(controll, animated: true)
    }
}

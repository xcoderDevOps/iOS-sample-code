//
//  SupportVC.swift
//  GoldClean
//
//  Created by infolabh on 18/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class SupportLisCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var stripView: UIView!
}

class SupportVC: UIViewController {

    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var rightBar : UIBarButtonItem!
    var supportList = [SupportData]()
    var filterList = [SupportData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        leftMenuButton()
        rightBar = UIBarButtonItem(title: "+ Add", style: UIBarButtonItem.Style.done, target: self, action: #selector(tapToAddSupportTicket))
        self.navigationItem.setRightBarButton(rightBar, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callSupportListAPI { (data) in
            self.supportList = data
            if self.segmentView.selectedSegmentIndex == 0 {
                self.filterList = self.supportList.filter({$0.Status != "Solved"})
            } else {
                self.filterList = self.supportList.filter({$0.Status == "Solved"})
            }
            
            self.tableView.reloadData()
        }
    }
    
    @objc func tapToAddSupportTicket() {
        let controll = MainBoard.instantiateViewController(identifier: "CreateSupportTicketVC") as! CreateSupportTicketVC
        self.navigationController?.pushViewController(controll, animated: true)
    }
    
    @IBAction func tapToChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            filterList = self.supportList.filter({$0.Status != "Solved"})
        } else {
            filterList = self.supportList.filter({$0.Status == "Solved"})
        }
        self.tableView.reloadData()
    }

}
extension SupportVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SupportLisCell") as! SupportLisCell
        if segmentView.selectedSegmentIndex == 0 {
            cell.stripView.backgroundColor = UIColor(red: 255.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        } else {
            cell.stripView.backgroundColor = UIColor(red: 50.0/255.0, green: 1.0, blue: 50.0/255.0, alpha: 1.0)
        }
        
        let obj = self.filterList[indexPath.row]
        
        cell.lblTitle.text = obj.Issue
        cell.lblSubTitle.text = obj.CreatedDateStr
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controll = MainBoard.instantiateViewController(identifier: "SupportChatVC") as! SupportChatVC
        controll.supportData = self.filterList[indexPath.row]
        self.navigationController?.pushViewController(controll, animated: true)
    }
}


//
//  AvailableBidListVC.swift
//  CargoXpress
//
//  Created by infolabh on 08/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class AvailableBidCell : UITableViewCell
{
    //MARK: - Variable declaration -
    @IBOutlet weak var lblTimeRemain: UILabel!
    @IBOutlet weak var lblLowestBid: UILabel!
    @IBOutlet weak var lblMyBid: UILabel!
    @IBOutlet weak var btnChangeBid: LetsButton!
    @IBOutlet weak var btnInfo: UIButton!
    
    var blockChangeBid : (() -> ())?
    var blockInfoClick : (() -> ())?
    
    @IBAction func btnChangeBidClicked(_ sender: UIButton) {
        if blockChangeBid != nil {
            blockChangeBid!()
        }
    }
    
    @IBAction func btnInfoClicked(_ sender: UIButton) {
        if blockInfoClick != nil {
            blockInfoClick!()
        }
    }
}

class AvailableBidListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        leftDriverMenuButton()
        // Do any additional setup after loading the view.
    }
}

extension AvailableBidListVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableBidCell") as! AvailableBidCell
        cell.lblTimeRemain.text = "Weak Floort packet\n30-May-2020"
        cell.lblLowestBid.text = "$30"
        cell.lblMyBid.text = "$32"
        cell.blockChangeBid = { () -> Void in
            
            _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupChangeBidVC", blockOK: { (obj) in
                dismissPopUp()
            }, blockCancel: {
                dismissPopUp()
            }, objData: nil)
        }
        cell.blockInfoClick = { () -> Void in
            let controll = DriverBoard.instantiateViewController(identifier: "AvailableJobListVC") as! AvailableJobDetailsVC
            controll.isFromBidList = true
            self.navigationController?.pushViewController(controll, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

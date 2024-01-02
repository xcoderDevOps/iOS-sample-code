//
//  AddressVC.swift
//  SOS
//
//  Created by Alpesh Desai on 28/12/20.
//

import UIKit

class AddressListCell : UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var blockActionCLK : (()->())?
    var blockDetailCLK : (()->())?
    var blockDeletCLK : (()->())?
    
    @IBAction func btnActionClk(_ sender: UIButton) {
        if blockActionCLK != nil {
            blockActionCLK!()
        }
    }
    
    @IBAction func btnViewDetailClk(_ sender: UIButton) {
        if blockDetailCLK != nil {
            blockDetailCLK!()
        }
    }
    
    @IBAction func btnDeleteClk(_ sender: UIButton) {
        if blockDeletCLK != nil {
            blockDeletCLK!()
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class AddressVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var arrayData = [AddressListData]()
    static var refresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Address"
        leftMenuButton()
        callAPI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AddressVC.refresh {
            AddressVC.refresh = false
            callAPI()
        }
        dashTabVC?.title = "My Address"
    }
    
    func callAPI() {
        callGetAddressList { (data) in
            self.arrayData = data
            self.tableView.reloadData()
        }
    }
    
    @IBAction func btnAddAddressClk(_ sender: UIButton) {
        if arrayData.count < UserInfo.savedUser()!.AddressCount {
            let controll = MainBoard.instantiateViewController(identifier: "AddEditAddressVC") as! AddEditAddressVC
            self.navigationController?.pushViewController(controll, animated: true)
        } else {
            showAlert("You can add only \(UserInfo.savedUser()!.AddressCount) address with this Plan")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell") as! AddressListCell
        let obj = arrayData[indexPath.row]
        cell.lblTitle.text = obj.AddressName
        cell.lblSubTitle.text = obj.Address
        cell.blockActionCLK = { () -> Void in
            let controll = MainBoard.instantiateViewController(identifier: "AddEditAddressVC") as! AddEditAddressVC
            controll.addressData = self.arrayData[indexPath.row]
            self.navigationController?.pushViewController(controll, animated: true)
        }
        cell.blockDetailCLK = { () -> Void in
            let controll = MainBoard.instantiateViewController(identifier: "AddressDetailVC") as! AddressDetailVC
            controll.addressData = self.arrayData[indexPath.row]
            self.navigationController?.pushViewController(controll, animated: true)
        }
        
        cell.blockDeletCLK = { () -> Void in
            self.alertShow(self, title: "", message: "Are you sure you want to delete this address?", okStr: "Yes", cancelStr: "No") {
                let url = baseURL + URLS.CustomerAddressesDelete.rawValue + "\(self.arrayData[indexPath.row].Id)"
                self.callDeleteContact(url) { (str) in
                    if str == "true" {
                        self.arrayData.remove(at: indexPath.row)
                        self.tableView.reloadData()
                    }
                }
            } cancelClick: {}

        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

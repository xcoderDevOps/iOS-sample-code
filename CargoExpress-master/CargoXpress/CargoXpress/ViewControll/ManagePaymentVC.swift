//
//  ManagePaymentVC.swift
//  GoldClean
//
//  Created by infolabh on 18/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class CardNumCell : UITableViewCell {

    @IBOutlet weak var imgCard: UIImageView!
    @IBOutlet weak var lblVal: UILabel!
    @IBOutlet weak var lblPrimary: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var lblCardNum: UILabel!
    
}

class ManagePaymentVC: UIViewController {

    
    var rightBar : UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        leftMenuButton()
        title = "Payment Method"
        rightBar = UIBarButtonItem(title: "Add Card", style: UIBarButtonItem.Style.done, target: self, action: #selector(addNewCardVC))
        self.navigationItem.setRightBarButton(rightBar, animated: true)
        // Do any additional setup after loading the view.
    }
    
    @objc func addNewCardVC() {
        _ = displayViewController(SLpopupViewAnimationType.fade, nibName: "PopupAddNewCardVC", blockOK: { (obj) in
            dismissPopUp()
        }, blockCancel: {
            dismissPopUp()
        }, objData: nil)
    }

}

extension ManagePaymentVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardNumCell") as! CardNumCell
        if indexPath.row == 0 {
            cell.lblPrimary.text = "Primary"
            cell.imgSelect.image = #imageLiteral(resourceName: "ic_tick")
        } else {
            cell.lblPrimary.text = ""
            cell.imgSelect.image = nil
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

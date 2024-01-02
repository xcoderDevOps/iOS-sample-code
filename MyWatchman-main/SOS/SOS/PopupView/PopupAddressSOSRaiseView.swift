//
//  PopupAddressSOSRaiseView.swift
//  SOS
//
//  Created by Alpesh Desai on 09/07/21.
//

import UIKit

class PopupAddressSOSRaiseView: MyPopupController {
    
    @IBOutlet weak var lblAddress : UILabel!
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let add = NeedHelpVC.arrayAddress.first {
            lblAddress.text = add.AddressName
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func openAddressListClk(_ sender: UIButton) {
        openDropDown(anchorView: sender, data: NeedHelpVC.arrayAddress.compactMap({$0.AddressName})) { (str, index) in
            self.lblAddress.text = str
            self.selectedIndex = index
        }
    }
    
    @IBAction func btnOkClk(_ sender: UIButton) {
        if pressOK != nil {
            self.pressOK!(self.selectedIndex as AnyObject)
        }
    }
    
    @IBAction func btnCancelClk(_ sender: UIButton) {
        if pressCancel != nil {
            self.pressCancel!()
        }
    }

}

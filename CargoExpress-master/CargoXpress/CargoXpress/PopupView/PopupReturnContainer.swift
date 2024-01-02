//
//  PopupReturnContainer.swift
//  CargoXpress
//
//  Created by infolabh on 23/08/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class PopupReturnContainer: MyPopupController  {

    @IBOutlet weak var btnReturn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnPathToReturnCLK(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnOkCLK(_ sender: UIButton) {
        if self.pressOK != nil {
            self.pressOK!(btnReturn.isSelected as AnyObject)
        }
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        if pressCancel != nil {
            pressCancel!()
        }
    }

}

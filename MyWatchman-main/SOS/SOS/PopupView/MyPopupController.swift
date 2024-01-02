//
//  MyPopupController.swift
//  SnowMowr
//
//  Created by Lokesh Dudhat on 20/11/15.
//  Copyright © 2015 com.letsnurture. All rights reserved.
//

import Foundation
import UIKit

class MyPopupController: UIViewController {

    var pressOK : ((_ objData : AnyObject?)-> ())?
    var pressCancel : (()-> ())?
    var objData : AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 0
        self.view.layer.masksToBounds = true
        self.view.frame = {
            var frm = self.view.frame
            frm.size.width = UIScreen.main.bounds.width
            frm.size.height = UIScreen.main.bounds.height
            return frm
        }()
    }    
}

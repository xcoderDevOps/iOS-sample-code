//
//  SelectLoginTypeVC.swift
//  CargoXpress
//
//  Created by infolabh on 28/04/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit

class SelectLoginTypeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnTapOnFindServiceCLK(_ sender: UIButton) {
        let conroll = LoginBord.instantiateViewController(identifier: "LoginVC") as! LoginVC
        appDelegate.isFindService = true
        self.navigationController?.pushViewController(conroll, animated: true)
    }
    
    @IBAction func btnTapOnBecomeCarrierCLK(_ sender: UIButton) {
        let conroll = LoginBord.instantiateViewController(identifier: "LoginVC") as! LoginVC
        appDelegate.isFindService = false
        self.navigationController?.pushViewController(conroll, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

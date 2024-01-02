//
//  WelcomeScreenVC.swift
//  SOS
//
//  Created by Alpesh Desai on 04/03/21.
//

import UIKit

class WelcomeScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCancelCLK(_ sender: UIButton) {
        registerData = RegisterData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnGoToDashboardCLK(_ sender: UIButton) {
        appDelegate.gotToDashBoardView()
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

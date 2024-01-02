//
//  SOSCompletedVC.swift
//  SOS
//
//  Created by Alpesh Desai on 02/04/21.
//

import UIKit

class SOSCompletedVC: UIViewController {

    @IBOutlet weak var lblTitle : UILabel!
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = "You have received help in just \(time) minutes"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapToGoToHome(_ sender:UIButton) {
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

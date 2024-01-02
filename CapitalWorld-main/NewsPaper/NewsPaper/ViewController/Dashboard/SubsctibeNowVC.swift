//
//  SubsctibeNowVC.swift
//  NewsPaper
//
//  Created by Alpesh Desai on 13/01/22.
//

import UIKit

class SubsctibeNowVC: UIViewController {

    var completionBlk: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func tapOnSubscribeNow(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if self.completionBlk != nil {
                self.completionBlk!()
            }
        }
    }

    @IBAction func tapOnCancel(_ sender: UIButton) {
        self.dismiss(animated: true) {}
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

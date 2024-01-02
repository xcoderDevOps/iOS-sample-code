//
//  PopupSosRaiseView.swift
//  SOS
//
//  Created by Alpesh Desai on 09/07/21.
//

import UIKit

class PopupSosRaiseView: MyPopupController {
    
    @IBOutlet weak var lblSeconds: UILabel!
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tapOnTimerSelection), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    var timeLot = 10
    @objc func tapOnTimerSelection() {
        timeLot = timeLot - 1
        if timeLot == 0 {
            timer?.invalidate()
            timer = nil
            if pressOK != nil {
                pressOK!(nil)
            }
        } else {
            lblSeconds.text = "\(timeLot)"
        }
    }

    @IBAction func btnRaiseSOS(_ sender: UIButton) {
        timer?.invalidate()
        timer = nil
        if pressOK != nil {
            pressOK!(nil)
        }
    }
    
    @IBAction func btnDismissPopup(_ sender: UIButton) {
        timer?.invalidate()
        timer = nil
        if pressCancel != nil {
            pressCancel!()
        }
    }

}

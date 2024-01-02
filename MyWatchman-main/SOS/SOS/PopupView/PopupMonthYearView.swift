//
//  PopupMonthYearView.swift
//  SOS
//
//  Created by Alpesh Desai on 01/01/21.
//

import UIKit

class PopupMonthYearView: MyPopupController {

    @IBOutlet weak var lblDateMonth: UILabel!
    @IBOutlet weak var picker: UIView!
    var monthYear = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let expiryDatePicker = MonthYearPickerView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.width-24, height: 200.0))
        expiryDatePicker.onDateSelected = { (month: Int, year: Int) in
            self.monthYear = String(format: "%d-%02d", year, month)
            self.lblDateMonth.text = String(format: "Year %d, Month %02d", year, month)
        }
        self.monthYear = String(format: "%d-%02d", expiryDatePicker.year, 01)
        self.lblDateMonth.text = String(format: "Year %d, Month %02d", expiryDatePicker.years.first!, 01)
        picker.addSubview(expiryDatePicker)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnDismissCLK(_ sender: UIButton) {
        if pressCancel != nil {
            pressCancel!()
        }
    }

    @IBAction func btnMonthCLK(_ sender: UIButton) {
        if pressOK != nil {
            pressOK!(monthYear as AnyObject)
        }
    }
}

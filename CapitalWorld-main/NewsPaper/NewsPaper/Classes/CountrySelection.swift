//
//  CountrySelection.swift
//  Via
//
//  Created by Ron Gupta on 11/08/16.
//  Copyright © 2017 Via Technology. All rights reserved.
//

import UIKit

var arrCountryCodes = fetchCounrtyCodes()

class CountrySelection: NSObject,UIPickerViewDelegate,UIPickerViewDataSource {
    class var sharedInstance : CountrySelection {
        struct Static {
            static let instance : CountrySelection = CountrySelection()
        }
        return Static.instance
    }
    func openCountryPicker(_ complication : ((CountryCodes) -> ())?){
        let style = RMActionControllerStyle.white
        
        let selectAction = RMAction<UIPickerView>(title: "Select", style: RMActionStyle.done) { controller in
            
            if let pickerController = controller as? RMPickerViewController{
                if let block = complication {
                    block(arrCountryCodes[Int(truncating: pickerController.picker.selectedRow(inComponent: 0) as NSNumber)])
                }
            }
        }
        
        let cancelAction = RMAction<UIPickerView>(title: "Cancel", style: RMActionStyle.cancel) { _ in
            // print("Row selection was canceled")
        }
        
        let actionController = RMPickerViewController(style: style, title: "", message: "Select Country Code", select: selectAction, andCancel: cancelAction)!;
        
        actionController.picker.tag = 1
        
        //You can enable or disable blur, bouncing and motion effects
        
        actionController.picker.delegate = self;
        actionController.picker.dataSource = self;
        
        //Now just present the date selection controller using the standard iOS presentation method
        appDelegate.window!.rootViewController!.present(actionController, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return arrCountryCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        let country = arrCountryCodes[row]
        return ("\(country.dial_code) \(country.name)")
    }
}

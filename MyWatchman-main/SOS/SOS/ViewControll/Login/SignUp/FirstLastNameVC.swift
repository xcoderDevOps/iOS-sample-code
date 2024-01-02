//
//  FirstLastNameVC.swift
//  SOS
//
//  Created by Alpesh Desai on 04/03/21.
//

import UIKit

struct RegisterData {
    var first = ""
    var last = ""
    var email = ""
    var phoneNum = ""
    var username = ""
    var country = CountryData()
    var password = ""
}

var registerData = RegisterData()

class FirstLastNameVC: UIViewController {

    @IBOutlet weak var txtFirst: LetsTextField!
    @IBOutlet weak var txtLast: LetsTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnDismissCLK(_ sender: UIButton) {
        registerData = RegisterData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnContinueCLK(_ sender: UIButton) {
        if  isEmptyString(txtFirst.text!) || isEmptyString(txtLast.text!)
        {
            showAlert(popUpMessage.emptyString.rawValue)
            return
        }
        registerData.first = txtFirst.text!
        registerData.last = txtLast.text!
        let controll = LoginBord.instantiateViewController(identifier: "EnterEmailVC") as! EnterEmailVC
        self.navigationController?.pushViewController(controll, animated: true)
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

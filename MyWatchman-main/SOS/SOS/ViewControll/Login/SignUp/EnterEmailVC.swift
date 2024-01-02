//
//  EnterEmailVC.swift
//  SOS
//
//  Created by Alpesh Desai on 04/03/21.
//

import UIKit

class EnterEmailVC: UIViewController {

    @IBOutlet weak var txtEmail: LetsTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnDismissCLK(_ sender: UIButton) {
        registerData = RegisterData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBackCLK(_ sender: UIButton) {
        registerData.email = txtEmail.text!
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueCLK(_ sender: UIButton) {
        registerData.email = txtEmail.text!
        let controll = LoginBord.instantiateViewController(identifier: "EnterUserNamePhoneVC") as! EnterUserNamePhoneVC
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

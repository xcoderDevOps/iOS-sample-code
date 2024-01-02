//
//  PaymentOptionVC.swift
//  SOS
//
//  Created by Alpesh Desai on 13/07/21.
//

import UIKit
import SafariServices

class PaymentOptionCell: UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgCard:UIImageView!
    @IBOutlet weak var imgSelect:UIImageView!
}

class PaymentOptionVC: UIViewController {

    var arrayOption = ["Mobile Money\n(Coming Soon)","TipMe\n(Coming Soon)","Orange Money\n(Coming Soon)","Visa / Mastercard"]
    var imgArray = ["Seek","tipme","Orange","visamaster"]
    var flag = [Bool]()
    @IBOutlet weak var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        title = "Payment Options"
        flag = Array.init(repeating: false, count: arrayOption.count)
        flag[3] = true
        // Do any additional setup after loading the view.
    }

    @IBAction func taponPaymentClk(_ sender: UIButton) {
        let url = URL(string: "https://payment.my-watchman.com/payment.aspx?mobile=\(UserInfo.savedUser()!.Mobile)")
        let svc = SFSafariViewController(url: url!)
        svc.view.tintColor = UIColor.systemBlue
        self.present(svc, animated: true, completion: nil)
    }
    
}

extension PaymentOptionVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOption.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentOptionCell") as! PaymentOptionCell
        cell.lblTitle.text = arrayOption[indexPath.row]
        cell.imgCard.image = UIImage(named: imgArray[indexPath.row])
        cell.imgSelect.image = UIImage(systemName: (flag[indexPath.row] ? "largecircle.fill.circle" : "circle"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //flag = Array.init(repeating: false, count: arrayOption.count)
        //flag[indexPath.row] = true
        //tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

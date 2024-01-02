//
//  NotificationVC.swift
//  SOS
//
//  Created by Alpesh Desai on 28/12/20.
//

import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var heightCon: NSLayoutConstraint!
    @IBOutlet weak var openBtn: UIButton!
    
    var blockTap: (()->())?
    
    @IBAction func tapOnOpen(_ sender:UIButton) {
        if blockTap != nil {
            blockTap!()
        }
    }
}

class NotificationVC: UIViewController {

    var arrayData = [NotificationData]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton()
        title = "Notifications"
        
        callGetNotificationList { (data) in
            self.arrayData = data
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }

}

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        let obj = arrayData[indexPath.row]
        
        cell.heightCon.constant = obj.Description.withoutHtml.heightOfString(UIFont(name: "Roboto-Regular", size: 17.0)!, width: cell.textView.frame.size.width) + 10.0
        
        let htmlData = NSString(string: obj.Description).data(using: String.Encoding.unicode.rawValue)
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        
        let attributedString = try! NSMutableAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        attributedString.addAttributes([NSAttributedString.Key.font:UIFont(name: "Roboto-Regular", size: 17.0)!], range: NSMakeRange(0, attributedString.length))
        cell.textView.attributedText = attributedString
        
        cell.lblDate.text = obj.ReadDateTime
        cell.openBtn.isHidden = arrayData[indexPath.row].SOSId == 0
        cell.blockTap = { () -> Void in
            if self.arrayData[indexPath.row].SOSId != 0 {
                let controll = MainBoard.instantiateViewController(identifier: "SOSDetailVC") as! SOSDetailVC
                controll.sosId = self.arrayData[indexPath.row].SOSId
                self.navigationController?.pushViewController(controll, animated: true)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

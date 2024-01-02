//
//  PaymentHistoryVC.swift
//  CargoXpress
//
//  Created by infolabh on 16/05/20.
//  Copyright © 2020 Rushkar. All rights reserved.
//

import UIKit
import SafariServices

class PaymentHistoryCell : UITableViewCell {
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblPaid: UILabel!
    @IBOutlet weak var lblFromTo: UILabel!
    @IBOutlet weak var lblJobAmt: UILabel!
    @IBOutlet weak var lblPendingAmt: UILabel!
    @IBOutlet weak var lblReceived: UILabel!
    @IBOutlet weak var lblNotMadePay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var stackThreeAmt: UIStackView!
    @IBOutlet weak var stackTwoDate: UIStackView!
    
}

class PaymentHistoryVC: UITableViewController {

    var arrayHistory = [TransectionHistoryData]()
    
    @IBOutlet weak var lblTotalEarn: UILabel!
    @IBOutlet weak var lblAdmin: UILabel!
    @IBOutlet weak var lblTrips: UILabel!
    
    @IBOutlet weak var lblTitleAdmin: UILabel!
    @IBOutlet weak var lblTitleEarn: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.isFindService {
            title = "My Expense"
            lblTitleEarn.text = "Total Expense"
            lblTitleAdmin.text = "From Admin"
            leftMenuButton()
        } else {
            leftDriverMenuButton()
            title = "My Earning"
            lblTitleEarn.text = "Total Earning"
            lblTitleAdmin.text = "To Admin"
        }
        
        let bar = UIBarButtonItem(image: UIImage(systemName: "arrow.down.doc"), style: UIBarButtonItem.Style.done, target: self, action: #selector(createPdfFromTableView))
        self.navigationItem.setRightBarButton(bar, animated: true)
        
        let id = appDelegate.isFindService ? "ShipperId=\(UserInfo.savedUser()!.Id)" : "CarrierId=\(UserInfo.savedUser()!.Id)"
        let url = baseURL+URLS.TransactionReport_ADVANCED.rawValue+id
        print(url)
        callGetTransectionHistoyuAPI(url: url) { (data) in
            self.arrayHistory = data
            
            let totlAmt = self.arrayHistory.compactMap({$0.Amount}).reduce(0, +)
            self.lblTrips.text = "\(self.arrayHistory.count)"
            self.lblTotalEarn.text = "$\(totlAmt)"
            self.tableView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    // MARK: - Table view data source

        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return arrayHistory.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentHistoryCell") as! PaymentHistoryCell
            let obj = arrayHistory[indexPath.row]
            
            if obj.IsPaymentExists {
                cell.stackTwoDate.isHidden = false
                cell.stackThreeAmt.isHidden = false
                cell.lblNotMadePay.isHidden = true
            } else {
                cell.stackTwoDate.isHidden = true
                cell.stackThreeAmt.isHidden = true
                cell.lblNotMadePay.isHidden = false
                cell.lblNotMadePay.text = "Payment not made (Job Amount: $\(obj.Price)"
            }
            
            cell.lblOrderNo.text = obj.JobNo
            cell.lblPaid.text = "Paid: $\(obj.Amount)"
            cell.lblJobAmt.text = "Job Amount\n$\(obj.Price)"
            cell.lblPendingAmt.text = "Pending\n$\(obj.AmountPending)"
            cell.lblDate.text = "Date: \(obj.PaymentDate)"
            cell.lblFromTo.text = "\(obj.PaidByUserTypeName) to\n\(obj.PaidToUserTypeName)"
            cell.lblReceived.text = "Received: \(obj.IsRecieved ? "Yes":"No")"

            return cell
        }
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 126.0
        }
        
    @objc func createPdfFromTableView()
    {
        let priorBounds: CGRect = tableView.bounds
        let fittedSize: CGSize = tableView.sizeThatFits(CGSize(width: priorBounds.size.width, height: tableView.contentSize.height))
        //tableView.bounds = CGRect(x: 0, y: 0, width: fittedSize.width, height: fittedSize.height)
        //tableView.reloadData()
        let pdfPageBounds: CGRect = CGRect(x: 0, y: 0, width: fittedSize.width, height: (fittedSize.height))
        let pdfData: NSMutableData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
        tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
        UIGraphicsEndPDFContext()
        let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        let documentsFileName = documentDirectories! + "/" + "pdfName.pdf"
        pdfData.write(toFile: documentsFileName, atomically: true)
        openBrowser(url: documentsFileName)
    }
    
    func openBrowser(url : String) {
        print(url)
        let url = URL(fileURLWithPath: url)
        let activityViewController = UIActivityViewController(activityItems: [url] , applicationActivities: nil)

        present(activityViewController,
            animated: true,
            completion: nil)
//        let config = SFSafariViewController.Configuration()
//        config.entersReaderIfAvailable = true
//        let vc = SFSafariViewController(url: url, configuration: config)
//        present(vc, animated: true)
    }
    
}

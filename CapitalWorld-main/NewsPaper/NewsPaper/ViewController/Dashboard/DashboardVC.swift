//
//  DashboardVC.swift
//  NewsPaper
//
//  Created by Alpesh Desai on 09/12/21.
//

import UIKit
import DateScrollPicker
import WebKit

class DashboardVC: UIViewController {

    var dateFormate = "EEEE,\ndd MMM yyyy"
    @IBOutlet weak var dateScrollPicker: DateScrollPicker!
    @IBOutlet weak var detailDateLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var btnToday: UIButton!
    
    @IBOutlet weak var viewExpirePlan: UIView!
    @IBOutlet weak var lblExpirePlan: UILabel!
    
    @IBOutlet weak var lblNoPaperMsg: UILabel!
    
    var selectedDate: Date? {
        didSet {
            if let date = selectedDate, Date().toString("dd-MM-yyyy")! == date.toString("dd-MM-yyyy")! {
                btnToday.isEnabled = false
            } else {
                btnToday.isEnabled = true
            }
            callAPIForPaper()
        }
    }
    
    var paperFileData : PaperFileData?
    var filePath : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblNoPaperMsg.isHidden = true
        dateScrollPicker.format.days = 5
        dateScrollPicker.format.topTextColor = UIColor(named: "AccentColor")!
        dateScrollPicker.format.topTextSelectedColor = UIColor.white
        dateScrollPicker.format.dayBackgroundColor = UIColor(red: 0.075, green: 0.073, blue: 0.217, alpha: 0.3)
        dateScrollPicker.format.dayBackgroundSelectedColor = UIColor(named: "AccentColor")!
        dateScrollPicker.format.separatorBottomFont = UIFont.boldSystemFont(ofSize: 17.0)
        dateScrollPicker.delegate = self
        viewExpirePlan.isHidden = true
        detailDateLabel.text = Date().toString(dateFormate)!
        print(UserInfo.savedUser())
        if let info = UserInfo.savedUser(), info.IsFiestTimeLogin {
            dateScrollPicker.isHidden = true
            self.openRegistrationPage(info: info)
        } else {
            let url = baseURL + URLS.Users_ById.rawValue + "\(UserInfo.savedUser()!.Id)&DeviceUDId=\(UIDevice.current.identifierForVendor!.uuidString)"
            callGetUserData(url, param: [String:Any]()) { (data, code, msg) in
                if code == 400 {
                    UserInfo.clearUser()
                    appDelegate.gotToSigninView()
                } else if let data = data {
                    data.save()
                    self.loadPaper()
                }
            }
            self.loadPaper()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let info = UserInfo.savedUser(), !info.IsFiestTimeLogin {
            self.loadPaper()
        }
    }
    
    func loadPaper() {
        if let info = UserInfo.savedUser(), let payDate = info.PaymentDateStr.toDate("yyyy-MM-dd") {
            let expDate = payDate.plusYears(1)
            let remainDay = Date().daysBetweenDay(expDate.minusDays(5))
            if expDate > Date() && remainDay > -5 {
                self.viewExpirePlan.isHidden = false
                self.lblExpirePlan.text = "Your Plan will be expire after \(remainDay) day."
                dateScrollPicker.isHidden = false
                DispatchQueue.main.async {
                    self.dateScrollPicker.selectToday()
                    self.selectedDate = Date()
                }
            }
            else if expDate < Date().plusDays(1) {
                self.openRegistrationPage(info: UserInfo.savedUser()!)
            }
            else {
                self.viewExpirePlan.isHidden = true
                dateScrollPicker.isHidden = false
                DispatchQueue.main.async {
                    self.dateScrollPicker.selectToday()
                    self.selectedDate = Date()
                }
            }
            
        } else if let info = UserInfo.savedUser(), info.PaymentDateStr.isEmpty {
            self.openRegistrationPage(info: UserInfo.savedUser()!)
        }
        else {
            self.viewExpirePlan.isHidden = true
            dateScrollPicker.isHidden = false
            DispatchQueue.main.async {
                self.dateScrollPicker.selectToday()
                self.selectedDate = Date()
            }
        }
    }
    
    func openRegistrationPage(info: UserInfo) {
        let controll = LoginBord.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        controll.completionBlk = { () -> Void in
            self.loadPaper()
        }
        controll.modalPresentationStyle = .fullScreen
        appDelegate.window?.rootViewController?.present(controll, animated: true, completion: nil)
    }
    
    func openOfferPage() {
        let con = MainBoard.instantiateViewController(withIdentifier: "SubsctibeNowVC") as! SubsctibeNowVC
        con.modalPresentationStyle = .overCurrentContext
        con.completionBlk = { () -> Void in
            self.dateScrollPicker.isHidden = false
            DispatchQueue.main.async {
                self.dateScrollPicker.selectToday()
                self.selectedDate = Date()
            }
        }
        appDelegate.window?.rootViewController?.present(con, animated: true, completion: nil)
    }
    
    func callAPIForPaper() {
//        self.webView.reload()
        webView.load(URLRequest(url: URL(string: "about:blank")!))
        self.resetAndCallAPI()
//        webView.load(URLRequest(url: URL(string: "about:blank")!))
//        webView.evaluateJavaScript("document.body.remove()") { obj, error in
//            self.resetAndCallAPI()
//        }
    }

    func resetAndCallAPI() {
        paperFileData = nil
        self.filePath = nil
        if let date = selectedDate, let str = date.toString("yyyy-MM-dd") {
            let url = baseURL + URLS.UploadedFiles_ByDate.rawValue + "\(str)&UserId=\(UserInfo.savedUser()!.Id)"
            print(url)
            callGetPaperData(url) { data in
                if let data = data {
                    if !data.FileUrl.isEmpty && data.FileUrl.contains(".pdf") {
                        FileDownloader.loadFileAsync(url: URL(string: data.FileUrl)!) { (path, error) in
                            if let path = path {
                                self.filePath = path
                                self.paperFileData = data
                                let fUrl = URL(fileURLWithPath: path)
                                DispatchQueue.main.async {
                                    self.lblNoPaperMsg.isHidden = true
                                    self.webView.loadFileURL(fUrl, allowingReadAccessTo: fUrl)
                                }
                            } else {
                                self.webView.load(URLRequest(url: URL(string: "about:blank")!))
                            }
                        }
                    } else if !data.FileUrl.isEmpty {
                        FileDownloader.loadFileAsync(url: URL(string: data.FileUrl)!) { (path, error) in
                            if let path = path {
                                self.filePath = path
                                self.paperFileData = data
                                let fUrl = URL(fileURLWithPath: path)
                                DispatchQueue.main.async {
                                    self.lblNoPaperMsg.isHidden = true
                                    self.webView.loadFileURL(fUrl, allowingReadAccessTo: fUrl)
                                }
                            } else {
                                self.webView.load(URLRequest(url: URL(string: "about:blank")!))
                            }
                        }
                    } else {
                        self.lblNoPaperMsg.isHidden = false
                    }
                } else {
                    self.lblNoPaperMsg.isHidden = false
                }
            }
        }
    }

    private func goToday() {
        dateScrollPicker.selectToday()
        detailDateLabel.text = Date().toString(dateFormate)!
        selectedDate = Date()
    }
    
    @IBAction func tapOnDatePicker(_ sender: UIButton) {
        openDatePicker(formate: dateFormate, minDate: nil) { str, date in
            self.detailDateLabel.text = str
            self.selectedDate = date
            self.dateScrollPicker.selectDate(date)
            self.dateScrollPicker.scrollToDate(date)
        }
    }
    
    
    @IBAction func tapOnRenewPlanCLK(_ sender: UIButton) {
        guard let xDate = "15-04-2022".toDate("dd-MM-yyyy") else {
            return
        }
        
        MakePaymentScreen.shared.makePayment(vc: self) { id in
            let param = ["Id": 0,
                         "TransactionId": id,
                         "UserId": UserInfo.savedUser()!.Id,
                         "Time": Date().toString("yyyy-MM-dd'T'HH:mm:ss.SSSZ")!] as [String:Any]
            let url = baseURL + URLS.Payment_Upsert.rawValue
            self.callUpsertPayment(url, param: param) { data in
                let url = baseURL + URLS.Users_ById.rawValue + "\(UserInfo.savedUser()!.Id)"
                self.callGetUserData(url, param: [String:Any]()) { (data, code, msg) in
                    if let data = data {
                        data.save()
                        self.loadPaper()
                    }
                }
            }
        }
    }
    
    @IBAction func tapOnRefreshPaperCLK(_ sender: UIButton) {
        callAPIForPaper()
    }
    
    @IBAction func tapOnExpandWebCLK(_ sender: UIButton) {
        if self.filePath != nil {
            let controll = MainBoard.instantiateViewController(withIdentifier: "FullScreenWebPaperVC") as! FullScreenWebPaperVC
            controll.modalPresentationStyle = .fullScreen
            controll.filePath = self.filePath
            self.present(controll, animated: true, completion: nil)
        } else {
            showAlert("Paper not available for this date yet")
        }
    }
    
    @IBAction func tapOnnotificationCLK(_ sender: UIButton) {
        let controll = MainBoard.instantiateViewController(withIdentifier: "NotificationListVC") as! NotificationListVC
        self.present(controll, animated: true, completion: nil)
    }
    
    @IBAction func tapOnTodayCLK(_ sender: UIButton) {
        goToday()
    }
}

extension DashboardVC: DateScrollPickerDelegate {
    func dateScrollPicker(_ dateScrollPicker: DateScrollPicker, didSelectDate date: Date) {
        detailDateLabel.text = date.toString(dateFormate)
        selectedDate = date
    }
}


class FileDownloader {

    static func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else if let dataFromURL = NSData(contentsOf: url)
        {
            if dataFromURL.write(to: destinationUrl, atomically: true)
            {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            }
            else
            {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl.path, error)
            }
        }
        else
        {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl.path, error)
        }
    }

    static func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)

        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
}

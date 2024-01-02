

import Foundation
import UIKit
import AVKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let MainBoard = UIStoryboard(name: "Main", bundle: nil)
let LoginBord = UIStoryboard(name: "Login", bundle: nil)
let onBord = UIStoryboard(name: "Onboard", bundle: nil)
func dismissPopUp()
{
    appDelegate.window?.rootViewController?.dismissPopupViewController(SLpopupViewAnimationType.fade)
}


func showAlert(_ message: String)
{
    if message.count > 0 {
        DispatchQueue.main.async(execute: {
            appDelegate.window!.makeToast(message: message , duration: 2, position: HRToastPositionCenter as AnyObject )
        })
    }
}

func AlertShowWithOK(_ title : String, message : String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
    appDelegate.window?.rootViewController!.present(alert, animated: true, completion: nil)
}

func displayViewController(_ animationType: SLpopupViewAnimationType,nibName : String, blockOK : ((_ objData : AnyObject?) -> ())?,blockCancel : (() -> ())?, objData : AnyObject?) -> MyPopupController {
    
    let myPopupViewController:MyPopupController = LoginBord.instantiateViewController(withIdentifier: nibName) as! MyPopupController
    myPopupViewController.pressOK = blockOK
    myPopupViewController.pressCancel = blockCancel
    myPopupViewController.objData = objData
    
    appDelegate.window?.rootViewController!.presentpopupViewController(myPopupViewController, animationType: animationType, completion: { () -> Void in
        
    })
    return myPopupViewController
}

func jsonStringConvert(_ dict : AnyObject) -> String {
    
    do {
        
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return  String(data: jsonData, encoding: String.Encoding.utf8)! as String
        
    } catch {
        return ""
    }
}

func setDeviceToken(_ token : String) {
    let defaults: UserDefaults = UserDefaults.standard
    let data: Data = NSKeyedArchiver.archivedData(withRootObject: token)
    defaults.set(data, forKey: "deviceToken")
    defaults.synchronize()
}
func removeDeviceToken() {
    let defaults: UserDefaults = UserDefaults.standard
    defaults.removeObject(forKey: "deviceToken")
    defaults.synchronize()
}
func getDeviceToken() -> String {
    let defaults: UserDefaults = UserDefaults.standard
    let data = defaults.object(forKey: "deviceToken") as? Data
    if data != nil {
        if let str = NSKeyedUnarchiver.unarchiveObject(with: data!) as? String {
            return str
        }
        else {
            return "11"
        }
    }
    return "11"
}



func topMostController() -> UIViewController
{
    var top = UIApplication.shared.keyWindow?.rootViewController
    while ((top?.presentedViewController) != nil)
    {
        top = top?.presentedViewController
    }
    return top!
}



func verifyUrl(urlString: String?) -> Bool {
    guard let urlString = urlString,
        let url = URL(string: urlString) else {
            return false
    }
    
    return UIApplication.shared.canOpenURL(url)
}

extension UITableView {
    func updateHeaderViewFrame() {
        guard let headerView = self.tableHeaderView else { return }
        headerView.layoutIfNeeded()
        let header = self.tableHeaderView
        self.tableHeaderView = header
    }
}

struct CountryCodes{
    var name = ""
    var dial_code = ""
    var code = ""
    
}


func fetchCounrtyCodes() -> [CountryCodes]{
    let name = "name"
    let dial_code = "dial_code"
    let code = "code"
    
    var countryArray = [CountryCodes]()
    
    guard let filePath = Bundle.main.path(forResource: "CountryList", ofType: "json") else {
        // print("File doesnot exist")
        return []
        }
    guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else{
        // print("error parsing data from file")
        return []
        }
    do {
        guard let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String:String]] else {
            // print("json doesnot confirm to expected format")
            return []
            }
        countryArray = jsonArray.map({ (object) -> CountryCodes in
            return CountryCodes(name: object[name]!, dial_code:object[dial_code]!, code: object[code]!)
            })
        }
    catch {
        // print("error\(error)")
        }
    return countryArray
}

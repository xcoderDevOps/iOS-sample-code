

import Foundation
import UIKit
import AVKit


let appDelegate = UIApplication.shared.delegate as! AppDelegate

let MainBoard = UIStoryboard(name: "Main", bundle: nil)
let DriverBoard = UIStoryboard(name: "Driver", bundle: nil)
let PopupBoard = UIStoryboard(name: "Popup", bundle: nil)
let LoginBord = UIStoryboard(name: "Login", bundle: nil)
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
    
    let myPopupViewController:MyPopupController = PopupBoard.instantiateViewController(withIdentifier: nibName) as! MyPopupController
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



func seperateAddressFromString (_ str : String) -> ( String, String )
{
    var strAddress = ""
    var  street = ""
    let array = str.components(separatedBy: ",")
    if array.count > 0 {
        street = array[0]
        
        for (i,obj) in array.enumerated()
        {
            var str = ""
            if array.count == 4
            {
                if i == 3
                {
                    str = obj.first == " " ? obj.dropFirst().base : obj
                }
                else
                {
                    str = obj.replacingOccurrences(of: " ", with: "")
                }
            }
            else
            {
                str = obj.replacingOccurrences(of: " ", with: "")
            }
            
            
            if i == 0 || i == 1
            {
                
            }
            else if i == 2
            {
                strAddress = strAddress + str
            }
            else
            {
                strAddress = strAddress + ", \(str)"
            }
        }
    }
    return ( street, strAddress)
}

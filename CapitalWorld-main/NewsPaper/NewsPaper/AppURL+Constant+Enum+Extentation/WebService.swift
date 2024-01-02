

import Foundation
import Alamofire
import SVProgressHUD

extension RegisterVC {
    func callGetPlanData(_ url:String, param:[String:Any], _ completionBLK:(( _ data :[PlanDataList])->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<PlanDataModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if completionBLK != nil {
                    completionBLK!(result.Values)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension UIViewController {
    func callGetCountryStateCity(_ url:String, _ completionBLK:(( _ data :[CountryStateData])->())?) {
        SVProgressHUD.show()
        
        let param = [   "Offset": 0,
                        "Limit": 0,
                        "IsOffsetProvided": true,
                        "Page": 0,
                        "PageSize": 0,
                        "SortBy": "string",
                        "TotalCount": 0,
                        "SortDirection": "string",
                        "IsPageProvided": true
                    ] as [String : Any]
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<CountryStateModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if completionBLK != nil {
                    completionBLK!(result.Values)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension ProfileVC {
    
    func callLogout(url : String,_ completionBLK:(( _ data :String?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { (response : DataResponse<String>) in
            SVProgressHUD.dismiss()
            if let str = response.result.value {
                if completionBLK != nil {
                    completionBLK!(str.replacingOccurrences(of: "\"", with: ""))
                }
            }
        }
    }
}

extension ChangePasswordVC {
    func callChangePass(_ url:String, param:[String:Any], _ completionBLK:(( _ data :UserInfo?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: URLEncoding.queryString, headers: nil).responseObject { (response : DataResponse<UserModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                showAlert(result.Message)
                if completionBLK != nil {
                    completionBLK!(result.Item)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension NotificationListVC {

    func callGetnotificationData(_ url:String, param:[String:Any], _ completionBLK:(( _ data :[NotificationDataList])->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<NotificationDataModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if completionBLK != nil {
                    completionBLK!(result.Values)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    
}

extension PaymentVC {
    func callGetTransectionData(_ url:String, param:[String:Any], _ completionBLK:(( _ data :[PaymentUpsertData])->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<TransectionDataModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if completionBLK != nil {
                    completionBLK!(result.Values)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension MakePaymentScreen {
    func callGetHashKey(_ url:String, param:[String:Any], _ completionBLK:(( _ data :String)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseString(queue: nil, encoding: nil) { response in
            SVProgressHUD.dismiss()
            if let res = response.result.value {
                if completionBLK != nil {
                    completionBLK!(res.replacingOccurrences(of: "\"", with: ""))
                }
            }
        }
    }
}

extension DashboardVC {
    func callGetPaperData(_ url:String, _ completionBLK:(( _ data :PaperFileData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<PaperFileModel>) in
            if let result = response.result.value {
                if result.IsValid {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                } else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
            SVProgressHUD.dismiss()
        }
    }
}

extension UIViewController {
    func callUpsertPayment(_ url:String, param:[String:Any], _ completionBLK:(( _ data :PaymentUpsertData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<PaymentUpsertModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if completionBLK != nil {
                    showAlert(result.Message)
                    completionBLK!(result.Item)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetUserData(_ url:String, param:[String:Any], _ completionBLK:(( _ data :UserInfo?,_ code:Int,_ msg:String)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: URLEncoding.queryString, headers: nil).responseObject { (response : DataResponse<UserModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.Code == "200" {
                    if completionBLK != nil {
                        completionBLK!(result.Item, 200, result.Message)
                    }
                } else if result.Code == "400" {
                    if completionBLK != nil {
                        completionBLK!(nil, 400, result.Message)
                    }
                } else {
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetUserUpsert(_ url:String, param:[String:Any], _ completionBLK:(( _ data :UserInfo?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<UserModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if completionBLK != nil {
                    completionBLK!(result.Item)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

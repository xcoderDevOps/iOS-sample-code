

import Foundation
import Alamofire
import SVProgressHUD

struct AddressComp {
    var address = ""
    var street = ""
    var areaName = ""
    var pincode = ""
    var city = ""
    var state = ""
    var country = ""
    
}

extension UIViewController {
    func getAddressFromLatLong(latitude: Double, longitude : Double, _ completion : ((_ add:AddressComp)->())?) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(GooglePlaceKey)"

        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:

                let responseJson = response.result.value! as! NSDictionary

                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                        var addressCom = AddressComp()
                        if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
                            print(addressComponents)
                            if let add = results[0]["formatted_address"] as? String {
                                addressCom.address = add
                            }
                            
                            for component in addressComponents {
                                if let temp = component.object(forKey: "types") as? [String] {
                                    if (temp[0] == "postal_code") {
                                        if let code =  component["long_name"] as? String {
                                            addressCom.pincode = code
                                        }
                                    }
                                    if (temp.count > 2 && temp[2] == "sublocality_level_1") {
                                        if let code =  component["long_name"] as? String {
                                            addressCom.areaName = code
                                        }
                                    }
                                    if (temp[0] == "locality") {
                                        if let city = component["long_name"] as? String {
                                            addressCom.city = city
                                        }
                                    }
                                    if (temp[0] == "route") {
                                        if let city = component["long_name"] as? String {
                                            addressCom.street = city
                                        }
                                    }
                                    if (temp[0] == "administrative_area_level_1") {
                                        if let state = component["long_name"] as? String {
                                            addressCom.state = state
                                        }
                                    }
                                    if (temp[0] == "country") {
                                        if let con = component["long_name"] as? String {
                                            addressCom.country = con
                                        }
                                    }
                                }
                            }
                            if completion != nil {
                                completion!(addressCom)
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callGetCountryList(_ completionBLK:(( _ data :[CountryData])->())?) {
        if checkInternet() {
            Alamofire.request(baseURL+URLS.GetAllCountryMaster.rawValue, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<CountryListModel>) in
                if let result = response.result.value {
                    if !result.Values.isEmpty {
                        if completionBLK != nil {
                            completionBLK!(result.Values)
                        }
                    }
                }
                else {
                    showAlert(popUpMessage.someWrong.rawValue)
                }
            }
        } else {
            showAlert(popUpMessage.NoInternet.rawValue)
        }
        
    }
    
    func callGetUserData(_ url:String, _ completionBLK:(( _ data :UserInfo?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response : DataResponse<UserModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
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
    
    func callPostUserDataAPI(url : String ,param : [String : Any] ,_ completionBLK:(( _ data :UserInfo?)->())?) {
        print(param)
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<UserModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetAddressList(_ completionBLK:(( _ data :[AddressListData])->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.CustomerAddrByCustomerId.rawValue+"?Id=\(UserInfo.savedUser()!.Id)&Offset=0&Limit=10000", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddressListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetSosList(_ completionBLK:(( _ data :[SOSTypeData])->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.SOSTypeAll.rawValue+"?Offset=0&Limit=10000", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SOSTypeListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetPlanDuration(_ completionBLK:(( _ data :[PlanDurationData])->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.SettingSelectAll.rawValue+"?Offset=0&Limit=10000", method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response : DataResponse<PlanDurationModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetPlanData(_ completionBLK:(( _ data :[PlanListData])->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.PlanSelectAll.rawValue+"?Offset=0&Limit=10000", method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response : DataResponse<PlanListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetPlanDetail(url:String ,_ completionBLK:(( _ data :PlanListData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<PlanDataModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    

    func callPostTransectionDetail(param:[String:Any] ,_ completionBLK:(( _ data :TransectionData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.TransactionDetailsUpsert.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<TransectionModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetRaiseSOS(id : Int ,_ completionBLK:(( _ data :SOSHistoryData?)->())?) {
        //SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.SOSByCustomerId.rawValue+"\(id)", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SOSHistoryModel>) in
            //SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callPostRaiseSOS(param : [String:Any] ,_ completionBLK:(( _ data :SOSHistoryData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.SOSUpsert.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SOSHistoryModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    //GetContactAll
    func callGetContactAll(_ completionBLK:(( _ data :[ContactData])->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.GetContactAll.rawValue+"\(UserInfo.savedUser()!.Id)&Offset=0&Limit=10000", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<ContactListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetRequestData(_ url:String, _ completionBLK:(( _ data :[UserInfo])->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response : DataResponse<UserListModel>) in
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
    
    func callDeleteContact(_ url:String, _ completionBLK:((_ flag:String)->())?) {
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
    
    func callApproveReject(url:String ,_ completionBLK:(( _ data :Bool?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<StatusMessageModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(true)
                    }
                    showAlert(result.Message)
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(false)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension LoginVC {
    func callLoginWithUrl(_ url:String, _ completionBLK:(( _ data :UserInfo?,_ flag:Bool)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response : DataResponse<UserModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.Code == "200" {
                    if completionBLK != nil {
                        completionBLK!(result.Item, true)
                    }
                } else if result.Code == "410" {
                    if completionBLK != nil {
                        completionBLK!(result.Item, false)
                    }
                }
                else {
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension SecurityQuestionsVC {
    func callGetQuestionList(_ completionBLK:(( _ data :[SecurityQuestionData])->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.SecurityQuestionsSelectAll.rawValue, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SecurityQuestionModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension ForgotPasswrodVC {
    func callPostForgot(url : String ,_ completionBLK:(( _ data :UserInfo?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<UserModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension AddEditAddressVC {
    func callAddAddress(param : [String : Any],_ completionBLK:(( _ data :AddressListData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.AddCustomerAddress.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddAddressModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                    showAlert(result.Message)
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension EditProfileVC {
    func callUploadProfileImage(img: UIImage?, completionBLK:((_ data : UserInfo?)->())?) {
        SVProgressHUD.show()
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            if let img = img, let imageData = img.jpegData(compressionQuality: 0.8) {
                multipartFormData.append(imageData, withName: "image", fileName: "\(Date().ticks).jpeg", mimeType: "image/jpeg")
            }
            
        },usingThreshold: 0 ,to:baseURL+URLS.ProfilePictUpdate.rawValue+"\(UserInfo.savedUser()!.Id)" , headers: nil, encodingCompletion: {
            encodingResult in switch encodingResult {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response : DataResponse<UserModel>) in
                    SVProgressHUD.dismiss()
                    if let result = response.result.value {
                        if result.IsSuccessStatusCode {
                            if completionBLK != nil {
                                completionBLK!(result.Item)
                            }
                        }
                        else {
                            if completionBLK != nil {
                                completionBLK!(nil)
                            }
                            showAlert(result.Message)
                        }
                    }
                    else {
                        showAlert(popUpMessage.someWrong.rawValue)
                    }
                })
                break
            case .failure(let error):
                print(error)
                SVProgressHUD.dismiss()
                showAlert(popUpMessage.someWrong.rawValue)
                // print(encodingError)
                break
            }
        })
    }
}

extension AddressDetailVC {
    func callGetSOSList(url:String,_ completionBLK:(( _ data :[SOSHistoryData])->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SOSHistoryListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension SOSRatingDetailPageVC {
    func callGetSOSRatingDetail(url:String,_ completionBLK:(( _ data :SOSHistoryData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SOSHistoryModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension SOSHistoryVC {
    func callGetSOSList(_ completionBLK:(( _ data :[SOSHistoryData])->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.SOSSelectAllByCustomerId.rawValue+"\(UserInfo.savedUser()!.Id)&Offset=0&Limit=10000", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SOSHistoryListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension NotificationVC {
    func callGetNotificationList(_ completionBLK:(( _ data :[NotificationData])->())?) {
        SVProgressHUD.show()
    
        Alamofire.request(baseURL+URLS.NotificationByCustomerId.rawValue+"\(UserInfo.savedUser()!.Id)&Offset=0&Limit=10000", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<NotificationListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension SOSMapPinScreenVC {
    
    func callGetSOSRatingDetail(url:String,_ completionBLK:(( _ data :SOSHistoryData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SOSHistoryModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension AddContactVC {
    func callAddContatDetail(param:[String:Any] ,_ completionBLK:(( _ data :ContactData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.EmergencyContactUpsert.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<ContactDataModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                    showAlert(result.Message)
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension UsersVC {
    func callGetSubUserData(_ url:String, _ completionBLK:(( _ data :[UserInfo])->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response : DataResponse<UserListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension AddSubUserVC {
    func callAddUserDetail(param:[String:Any] ,_ completionBLK:(( _ data :UserInfo?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.SubCustomerUpsert.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<UserModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                    showAlert(result.Message)
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension SOSDetailVC {
    func callGetSOS(id : Int, flag : Bool ,_ completionBLK:(( _ data :SOSHistoryData?)->())?) {
        if flag {
            SVProgressHUD.show()
        }
        
        Alamofire.request(baseURL+URLS.GetSOSById.rawValue+"\(id)", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SOSHistoryModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension SurveyTaskVC {
    func callPostAnsDetail(url:String, param:[[String:Any]] ,_ completionBLK:(( _ data :SOSCompleteData?)->())?){
        SVProgressHUD.show()

        let url = URL(string: url)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: param)
        SVProgressHUD.show()
        Alamofire.request(request).responseObject { (response :DataResponse<SOSCompleteModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                    showAlert(result.Message)
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callPostRatingDetail(param:[String:Any] ,_ completionBLK:(( _ data :RatingData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.RatingUpsert.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<RatingModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    //
    
    func callCompleteSOSHistory(sosId:String,_ completionBLK:(( _ data :SOSHistoryData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.SOSIsactiveORInactive.rawValue+sosId, method: HTTPMethod.post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response : DataResponse<SOSHistoryModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
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
}



extension BillingVC {
    
    func callGetBillingHistory(_ completionBLK:(( _ data :[BillingData])->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.billingHistory.rawValue+"\(UserInfo.savedUser()!.Id)&Offset=0&Limit=10000", method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response : DataResponse<BillingListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callCancelPanByCustomer(_ completionBLK:(( _ data :UserInfo?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.cancelPlan.rawValue+"\(UserInfo.savedUser()!.Id)", method: HTTPMethod.post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response : DataResponse<UserModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
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
    
}
extension StatisticsVC {
    func callGetStatistics(_ completionBLK:(( _ data :[StatasticData])->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.getStatastic.rawValue+"\(UserInfo.savedUser()!.Id)", method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response : DataResponse<StatasticListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension MedicalnfoVC {
    func callUpsertMedicalDetail(param:[String:Any] ,_ completionBLK:(( _ data :MedicalInfoData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.MedicalInfoUpsert.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<MedicalInfoModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                    showAlert(result.Message)
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetMedicalInfo(_ completionBLK:(( _ data :MedicalInfoData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.MedicalInfoById.rawValue+"\(UserInfo.savedUser()!.MedicalId)", method: HTTPMethod.post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response : DataResponse<MedicalInfoModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
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
}

extension InsurangeInfoVC {
    func callUpsertInsuranceDetail(param:[String:Any] ,_ completionBLK:(( _ data :InsuranceData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.InsuranceInfoUpsert.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<InsuranceModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                    showAlert(result.Message)
                }
                else {
                    if completionBLK != nil {
                        completionBLK!(nil)
                    }
                    showAlert(result.Message)
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetInsuranceInfo(_ completionBLK:(( _ data :InsuranceData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.InsuranceInfoById.rawValue+"\(UserInfo.savedUser()!.InsuranceId)", method: HTTPMethod.post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseObject { (response : DataResponse<InsuranceModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsSuccessStatusCode {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
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
}

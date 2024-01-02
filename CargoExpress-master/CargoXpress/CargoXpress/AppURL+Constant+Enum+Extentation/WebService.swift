

import Foundation
import Alamofire
import SVProgressHUD

extension AppDelegate {
    func callGetOtpData(url : String,_ completionBLK:(( _ data :String?)->())?) {
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

extension UIViewController {
    func callLoginSignUp(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :UserInfo?)->())?) {
        SVProgressHUD.show()
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<UserModel>) in
            SVProgressHUD.dismiss()
            if let res = response.response, res.statusCode == 200 {
                if let result = response.result.value {
                    if result.IsValid {
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
            } else {
                if completionBLK != nil {
                    completionBLK!(nil)
                }
                showAlert(popUpMessage.someWrong.rawValue)
            }
            
        }
    }
    
    func callGetPricePlan(userType : String, completionBLK:((_ data: [PriceData])->())? ) {
        //
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.MasterPricingPlans_All.rawValue+"\(userType)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<PriceModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("No Country Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callLogOut(url : String,_ completionBLK:((_ flag:Bool)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { (str) in
            SVProgressHUD.dismiss()
            if completionBLK != nil {
                completionBLK!(true)
            }
        }
    }
    
    func callGetCountryList(_ completionBLK:(( _ data :[CountryData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.countryAll.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<CountryModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("No Country Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    
    //
    func callGetServiceTypeList(id:Int,_ completionBLK:(( _ data :[ServiceTypeData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.TruckServices_All.rawValue+"\(id)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<ServiceTypeModel>) in
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
    
    func callGetAlljobList(url : String, flag:Bool, _ completionBLK:(( _ data :[JobData]?)->())?) {
        if flag {
            SVProgressHUD.show()
        }
        
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
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
        }
    }
    
    func calChangeJobStatus(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :JobData?)->())?) {
        SVProgressHUD.show()
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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
    
    //Shippers_ById
    func callGetUserData(url : String ,_ completionBLK:(( _ data :UserInfo?)->())?) {
        Alamofire.request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<UserModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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
    
    func callGetJobDataFromjobID(url : String ,_ completionBLK:(( _ data :JobData?)->())?) {
        Alamofire.request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobModel>) in
            if let result = response.result.value {
                if result.IsValid {
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
    
    func callInertPlan(url : String, param:[String:Any] ,_ completionBLK:(( _ data :PriceInsertData?)->())?) {
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<PriceInsertModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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
    
    func callGetRootData(jobId : String, completionBLK:((_ data: [RouteData])->())? ) {
        //
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.RouteMaster_ByJobId.rawValue+"\(jobId)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<RouteModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    //showAlert("No Country Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    //RouteDetailModel
    func callGetRootDetailData(rootId : String, completionBLK:((_ data: [RouteDetailData])->())? ) {
        //
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.RouteChild_ByRouteMasterId.rawValue+"\(rootId)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<RouteDetailModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("No Country Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetJobActivityData(jobId : String, completionBLK:((_ data: [JobStatusActivityData])->())? ) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.Job_Activity.rawValue+"\(jobId)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobStatusActivityModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("No Country Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetJobLocationData(jobId : String, driverId : String, completionBLK:((_ data: [JobLocationData])->())? ) {
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        let url = baseURL+URLS.jobTrackLocation.rawValue+"\(jobId)&DriverId=\(driverId)"
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobLocationModel>) in
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    //showAlert("No Country Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callRatingistListAPI(url : String ,_ completionBLK:(( _ data :[RatingData])->())?) {
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<RatingListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                   // showAlert("Data Not Found.")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callTruckDriverListAPI(job_id: String, _ completionBLK:(( _ data :[TruckDriverComboData])->())?) {
        let url = baseURL + URLS.JobTruckDrivers_ByJobId.rawValue + "\(job_id)"
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
    
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<TruckDriverComboList>) in
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
    
    func callAddDriverTrucj( _ param : [String:Any] ,_ completionBLK:(( _ data :TruckDriverComboData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.JobTruckDrivers_Upsert.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddTruckDriverCombo>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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
    
    func callDeleteTruckDriveData(id : String,_ completionBLK:(( _ data :String?)->())?) {
        Alamofire.request(baseURL+URLS.JobTruckDrivers_Delete.rawValue+id, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { (response : DataResponse<String>) in
            SVProgressHUD.dismiss()
            if let str = response.result.value {
                if completionBLK != nil {
                    completionBLK!(str.replacingOccurrences(of: "\"", with: ""))
                }
            }
        }
    }
    
    func callGetTransectionHistoyuAPI(url: String, _ completionBLK:(( _ data :[TransectionHistoryData])->())?) {
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
    
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<TransectionHistoryModel>) in
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
    func callPostBid(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :JobBidData?)->())?) {
        SVProgressHUD.show()
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddJobBidModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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
    func callAddService(url : String, _ param : [String:Any] ,_ completionBLK:(()->())?) {
        SVProgressHUD.show()
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddServiceModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
                    if completionBLK != nil {
                        completionBLK!()
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    //
    
    func callGetSelectedCountryList(_ completionBLK:(( _ data :[CountryData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.CarrierPreferedDestinations_All.rawValue+"\(UserInfo.savedUser()!.Id)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<CountryModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("No Truck Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetNotification(url : String, _ completionBLK:(( _ data :[NotificationData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<NotificationListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    if completionBLK != nil {
                        completionBLK!([])
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetNotificationCount(url:String,_ completionBLK:(( _ data :ReadNotificationItem?)->())?) {
        SVProgressHUD.show()
        let param = ["UserId": UserInfo.savedUser()!.Id,
                     "UserType": appDelegate.isFindService ? 3 : 2]
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<ReadNotificationModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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


extension DashboardVC {
    func callGetTruckTypeList(_ completionBLK:(( _ data :[TruckTypeData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.TruckTypes_All.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<TruckTypeModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("No Truck Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetLocationTypeList(_ completionBLK:(( _ data :[LocationTypeData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.LocationTypes_All.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<LocationTypeModel>) in
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

extension JobInformationVC {
    func callAddJob(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :JobData?)->())?) {
        SVProgressHUD.show()
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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

extension MyJobDetailBidVC {
    //JobBids_ByJobId
    func callGetBidList(url : String, _ completionBLK:(( _ data :[JobBidData])->())?) {
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobBidModel>) in
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

extension JobPaymentVC {
    func callAccceptBid(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :JobData?)->())?) {
        SVProgressHUD.show()
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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
    
    func callUploadImage(url : String, param:[String:String] ,data: DocData?, completionBLK:((_ data : DocumentData?)->())?) {
        print(param)
        SVProgressHUD.show()
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            if let data = data, let img = data.img, let imageData = img.jpegData(compressionQuality: 0.8) {
                multipartFormData.append(imageData, withName: "image", fileName: "\(Date().ticks).jpeg", mimeType: "image/jpeg")
            } else if let data = data, let pdf = data.data {
                multipartFormData.append(pdf, withName: "image", fileName: "\(Date().ticks).\(data.ext)", mimeType: "application/\(data.ext)")
            }
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            
        },usingThreshold: 0 ,to:url , headers: nil, encodingCompletion: {
            encodingResult in switch encodingResult {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response : DataResponse<DocumentModel>) in
                    SVProgressHUD.dismiss()
                    if let result = response.result.value {
                        if result.IsValid {
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


extension AvailableJobDetailsVC {

    
    func callGetBidList(url : String, _ completionBLK:(( _ data :[JobBidData])->())?) {
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobBidModel>) in
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

extension JobPaymentVC {
    //JobDocuments_Upsert
    func callUploadJobDocuments(param : [String : String], img: UIImage?,_ completionBLK:(( _ data :JobDocData?)->())?) {
        print(param)
        SVProgressHUD.show()
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            if let img = img, let imageData = img.jpegData(compressionQuality: 0.8) {
                multipartFormData.append(imageData, withName: "image", fileName: "\(Date().ticks).jpeg", mimeType: "image/jpeg")
            }
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        },usingThreshold: 0 ,to: baseURL + URLS.JobDocuments_Upsert.rawValue, headers: nil, encodingCompletion: {
            encodingResult in switch encodingResult {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response : DataResponse<JobDocModel>) in
                    SVProgressHUD.dismiss()
                    if let result = response.result.value {
                        if result.IsValid {
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

extension PopupAddDriverVC {
    
    func callInsertDriver(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :DriverData?)->())?) {
        SVProgressHUD.show()
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<DriverModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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

extension DriverListVC {
    func callGetDriverList(url : String, _ completionBLK:(( _ data :[DriverData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<DriverListModel>) in
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

extension PopupAddTruckVC {
    func callGetTruckTypeList(_ completionBLK:(( _ data :[TruckTypeData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.TruckTypes_All.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<TruckTypeModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("No Truck Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callInsertTruck(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :TruckData?)->())?) {
        SVProgressHUD.show()
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<TruckModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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

extension TruckAllMapScreenVC {
    func callGetTruckList(_ completionBLK:(( _ data :[TruckData])->())?) {
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.Truck_All.rawValue+"\(UserInfo.savedUser()!.Id)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<TruckListModel>) in
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("No Truck Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension CarrierListVC {
    func callGetTruckList(_ flag:Bool,_ completionBLK:(( _ data :[TruckData])->())?) {
        if flag {
            SVProgressHUD.show()
        }
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.Truck_All.rawValue+"\(UserInfo.savedUser()!.Id)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<TruckListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("No Truck Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension EditProfileVC {
    
    func callGetDocuemtnList(_ completionBLK:(( _ data :[DocumentData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.ShipperDocuments_ById.rawValue+"\(UserInfo.savedUser()!.Id)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<DocumentListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("No Data Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callUploadImage(url : String, param:[String:String] ,data: DocData?, completionBLK:((_ data : DocumentData?)->())?) {
        print(param)
        SVProgressHUD.show()
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            if let data = data, let img = data.img, let imageData = img.jpegData(compressionQuality: 0.8) {
                multipartFormData.append(imageData, withName: "image", fileName: "\(Date().ticks).jpeg", mimeType: "image/jpeg")
            } else if let data = data, let pdf = data.data {
                multipartFormData.append(pdf, withName: "image", fileName: "\(Date().ticks).\(data.ext)", mimeType: "application/\(data.ext)")
            }
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },usingThreshold: 0 ,to:url , headers: nil, encodingCompletion: {
            encodingResult in switch encodingResult {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response : DataResponse<DocumentModel>) in
                    SVProgressHUD.dismiss()
                    if let result = response.result.value {
                        if result.IsValid {
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

extension CarrierEditProfileVC {
    
    func callGetDocuemtnList(_ completionBLK:(( _ data :[DocumentData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.CarrierDocuments_All.rawValue+"\(UserInfo.savedUser()!.Id)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<DocumentListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
//                    showAlert("No Data Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callUploadImage(url : String, param:[String:String] ,data: DocData?, completionBLK:((_ data : DocumentData?)->())?) {
    print(param)
    SVProgressHUD.show()
    Alamofire.upload(multipartFormData: {
        multipartFormData in
        
        if let data = data, let img = data.img, let imageData = img.jpegData(compressionQuality: 0.8) {
            multipartFormData.append(imageData, withName: "image", fileName: "\(Date().ticks).jpeg", mimeType: "image/jpeg")
        } else if let data = data, let pdf = data.data {
            multipartFormData.append(pdf, withName: "image", fileName: "\(Date().ticks).\(data.ext)", mimeType: "application/\(data.ext)")
        }
        
        for (key, value) in param {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
        
        
    },usingThreshold: 0 ,to:url , headers: nil, encodingCompletion: {
            encodingResult in switch encodingResult {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response : DataResponse<DocumentModel>) in
                    SVProgressHUD.dismiss()
                    if let result = response.result.value {
                        if result.IsValid {
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

extension MyWonBidVC {
    func callUploadImage(url : String, param:[String:String] ,data: DocData?, completionBLK:((_ data : DocumentData?)->())?) {
    print(param)
    SVProgressHUD.show()
    Alamofire.upload(multipartFormData: {
        multipartFormData in
        
        if let data = data, let img = data.img, let imageData = img.jpegData(compressionQuality: 0.8) {
            multipartFormData.append(imageData, withName: "image", fileName: "\(Date().ticks).jpeg", mimeType: "image/jpeg")
        } else if let data = data, let pdf = data.data {
            multipartFormData.append(pdf, withName: "image", fileName: "\(Date().ticks).\(data.ext)", mimeType: "application/\(data.ext)")
        }
        
        for (key, value) in param {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
        
        
    },usingThreshold: 0 ,to:url , headers: nil, encodingCompletion: {
            encodingResult in switch encodingResult {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response : DataResponse<DocumentModel>) in
                    SVProgressHUD.dismiss()
                    if let result = response.result.value {
                        if result.IsValid {
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
    
    func callAddJob(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :JobData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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
    
    func callAddTruckDriverAPI(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :TruckDriverComboData?)->())?) {
        SVProgressHUD.show()
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddTruckDriverCombo>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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

extension CommentListVC {
    func callCommentList(url:String, _ completionBLK:(( _ data :[CommentData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<CommentModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    //showAlert("No Data Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callAddComment(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :CommentData?)->())?) {
        SVProgressHUD.show()
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddCommentModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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

extension SupportVC {
    //
    
    func callSupportListAPI(_ completionBLK:(( _ data :[SupportData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        let id = appDelegate.isFindService ? "ShipperId=\(UserInfo.savedUser()!.Id)" : "CarrierId=\(UserInfo.savedUser()!.Id)"
        Alamofire.request(baseURL+URLS.SupportAll.rawValue + id, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SupportModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("Ticket Not Found. Please create ticket if you have any issue.")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension SupportChatVC {
    func callSupportChatListAPI(supportId : String, flag : Bool, _ completionBLK:(( _ data :[SupportChatData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        if flag {
            SVProgressHUD.show()
        }
        Alamofire.request(baseURL+URLS.SupportChat.rawValue+"\(supportId)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SupportChatModel>) in
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
    

    func wsSupportCloseCLK(id:String, completionBLK : ((_ data : SupportChatData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.Support_Close.rawValue+"\(id)", method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SupportChatReplyModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                    //showAlert(result.Message)
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
    
    
    func wsSendReplyCLK(param:[String:Any], completionBLK : ((_ data : SupportChatData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.SupportChatReply.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SupportChatReplyModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
                    if completionBLK != nil {
                        completionBLK!(result.Item)
                    }
                    //showAlert(result.Message)
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

extension CreateSupportTicketVC {
    func wsAddTicketCLK(param:[String:Any], completionBLK : ((_ data : SupportChatData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.AddTicket.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<SupportChatReplyModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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


extension PaymentVC {
    func callUploadImage(url : String, param:[String:String] ,data: DocData?, completionBLK:((_ data : PaymentData?)->())?) {
    print(param)
    SVProgressHUD.show()
    Alamofire.upload(multipartFormData: {
        multipartFormData in
        
        if let data = data, let img = data.img, let imageData = img.jpegData(compressionQuality: 0.8) {
            multipartFormData.append(imageData, withName: "image", fileName: "\(Date().ticks).jpeg", mimeType: "image/jpeg")
        } else if let data = data, let pdf = data.data {
            multipartFormData.append(pdf, withName: "image", fileName: "\(Date().ticks).\(data.ext)", mimeType: "application/\(data.ext)")
        }
        
        for (key, value) in param {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
        
        
    },usingThreshold: 0 ,to:url , headers: nil, encodingCompletion: {
            encodingResult in switch encodingResult {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response : DataResponse<AddPaymentModel>) in
                    SVProgressHUD.dismiss()
                    if let result = response.result.value {
                        if result.IsValid {
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
    
    func callPaymentListAPI(url : String ,_ completionBLK:(( _ data :[PaymentData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<PaymentListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("Data Not Found.")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension PopupRatingVC {
    func wsAddRatingCLK(param:[String:Any], completionBLK : ((_ data : RatingData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.JobRatingUpsert.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddRatingModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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


extension BillOfLoadingVC {
    func callUploadImage(url : String, param:[String:String] ,data: DocData?, completionBLK:((_ data : BillOfLoadingData?)->())?) {
    print(param)
    SVProgressHUD.show()
    Alamofire.upload(multipartFormData: {
        multipartFormData in
        
        if let data = data, let img = data.img, let imageData = img.jpegData(compressionQuality: 0.8) {
            multipartFormData.append(imageData, withName: "image", fileName: "\(Date().ticks).jpeg", mimeType: "image/jpeg")
        } else if let data = data, let pdf = data.data {
            multipartFormData.append(pdf, withName: "image", fileName: "\(Date().ticks).\(data.ext)", mimeType: "application/\(data.ext)")
        }
        
        for (key, value) in param {
            multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
        }
        
        
    },usingThreshold: 0 ,to:url , headers: nil, encodingCompletion: {
            encodingResult in switch encodingResult {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response : DataResponse<AddBillOfLoadingModel>) in
                    SVProgressHUD.dismiss()
                    if let result = response.result.value {
                        if result.IsValid {
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
    
    func callPaymentListAPI(url : String ,_ completionBLK:(( _ data :[BillOfLoadingData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<BillOfLoadingListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("Data Not Found.")
                    if completionBLK != nil {
                        completionBLK!([])
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func wsDeleteBillCLK(id:String, completionBLK : ((_ flag : Bool?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.JobBillOfLoading_Delete.rawValue+"\(id)", method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddBillOfLoadingModel>) in
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

extension ReturnContainerDetailVC {
    
    func callAddJob(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :JobData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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
    //routeMaster/RouteMaster_Upsert
    func wsAddRoutMasterCLK(param:[String:AnyObject], completionBLK : ((_ data : RouteData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.RouteMaster_Upsert.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddRootMasterAddress>) in
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


extension ManageContainerRoutVC {
    func callAddContainerRoute(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :RouteData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddRootMasterAddress>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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
    
    func callAddChieldRoute(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :RouteDetailData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddRootChieldAddress>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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

extension TruckFualChartDataVC {
    func callGetFualDataAPI(url : String ,_ completionBLK:(( _ data :[TruckFualData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<TruckFualModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("Data Not Found.")
                    if completionBLK != nil {
                        completionBLK!([])
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension TruckStandAloneLocationVC {
    func callGetLocationDataAPI(url : String ,_ completionBLK:(( _ data :[TruckFualData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<TruckFualModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("Data Not Found.")
                    if completionBLK != nil {
                        completionBLK!([])
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension PopupAddFuelTankVC {
    
    func callGetFualTypeDataAPI(url : String ,_ completionBLK:(( _ data :[LocationTypeData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<LocationTypeModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("Data Not Found.")
                    if completionBLK != nil {
                        completionBLK!([])
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callGetTRUCKFualDataAPI(url : String ,_ completionBLK:(( _ data :[FualTypeData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<FualTypeModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    //showAlert("Data Not Found.")
                    if completionBLK != nil {
                        completionBLK!([])
                    }
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callDeleteTruckTypeData(id : String,_ completionBLK:(( _ data :String?)->())?) {
        Alamofire.request(baseURL+URLS.TruckFuel_Delete.rawValue+id, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { (response : DataResponse<String>) in
            SVProgressHUD.dismiss()
            if let str = response.result.value {
                if completionBLK != nil {
                    completionBLK!(str.replacingOccurrences(of: "\"", with: ""))
                }
            }
        }
    }
    
    func callUpsertFualTruck(url : String, _ param : [String:Any] ,_ completionBLK:(( _ data :FualTypeData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<AddFualTypeModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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


extension PopupAddTruckVC {
    func callUploadImage(url : String, param:[String:String] ,data: DocData?, completionBLK:((_ data : DocumentData?)->())?) {
        print(param)
        SVProgressHUD.show()
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            
            if let data = data, let img = data.img, let imageData = img.jpegData(compressionQuality: 0.8) {
                multipartFormData.append(imageData, withName: "image", fileName: "\(Date().ticks).jpeg", mimeType: "image/jpeg")
            } else if let data = data, let pdf = data.data {
                multipartFormData.append(pdf, withName: "image", fileName: "\(Date().ticks).\(data.ext)", mimeType: "application/\(data.ext)")
            }
            
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },usingThreshold: 0 ,to:url , headers: nil, encodingCompletion: {
            encodingResult in switch encodingResult {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response : DataResponse<DocumentModel>) in
                    SVProgressHUD.dismiss()
                    if let result = response.result.value {
                        if result.IsValid {
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
    
    func callGetDocuemtnList(truckId:String ,_ completionBLK:(( _ data :[DocumentData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.TruckDocuments_All.rawValue+"\(truckId)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<DocumentListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    //showAlert("No Data Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    //
    
    func callTruckActiveInActive(id : String,_ completionBLK:(( _ data :TruckData?)->())?) {
        SVProgressHUD.show()
        let url = baseURL+URLS.Trucks_ActInact.rawValue+"\(id)"
        Alamofire.request(url, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<TruckModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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

extension MyPlaceListVC {
    func callGetPlaceList(_ completionBLK:(( _ data :[MyPlaceData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.CarrierPlaces_All.rawValue+"\(UserInfo.savedUser()!.Id)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<MyPlaceListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("No Truck Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
    
    func callDeletePlaceData(id : String,_ completionBLK:(( _ data :String?)->())?) {
        Alamofire.request(baseURL+URLS.CarrierPlaces_Delete.rawValue+id, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { (response : DataResponse<String>) in
            SVProgressHUD.dismiss()
            if let str = response.result.value {
                if completionBLK != nil {
                    completionBLK!(str.replacingOccurrences(of: "\"", with: ""))
                }
            }
        }
    }
    
    func callAddNewPlace( _ param : [String:Any] ,_ completionBLK:(( _ data :MyPlaceData?)->())?) {
        SVProgressHUD.show()
        Alamofire.request(baseURL+URLS.CarrierPlaces_Upsert.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<MyPlaceModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if result.IsValid {
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

extension NotificationHeaderView {
    func callGetPlaceList(_ completionBLK:(( _ data :[MyPlaceData])->())?) {
        SVProgressHUD.show()
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(baseURL+URLS.CarrierPlaces_All.rawValue+"\(UserInfo.savedUser()!.Id)", method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<MyPlaceListModel>) in
            SVProgressHUD.dismiss()
            if let result = response.result.value {
                if !result.Values.isEmpty {
                    if completionBLK != nil {
                        completionBLK!(result.Values)
                    }
                } else {
                    showAlert("No Truck Found")
                }
            }
            else {
                showAlert(popUpMessage.someWrong.rawValue)
            }
        }
    }
}

extension PopupSelectBidVC {
    func callGetFinanceBid(url:String, _ completionBLK:(( _ data :[JobBidFinanceData])->())?) {
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobBidFinanceListModel>) in
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

extension PopupChangeBidVC {
    func callGetFinanceBid(url:String, _ completionBLK:(( _ data :[JobBidFinanceData])->())?) {
        let param = [ "Offset": 0,
                      "Limit": 100000,
                      "IsOffsetProvided": true,
                      "Page": 0,
                      "PageSize": 0,
                      "SortBy": "string",
                      "TotalCount": 0,
                      "SortDirection": "string",
                      "IsPageProvided": true ] as [String : Any]
        Alamofire.request(url, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobBidFinanceListModel>) in
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
    
    
    func callAddJobFinance( _ param : [String:Any] ,_ completionBLK:(( _ data :JobBidFinanceData?)->())?) {
        Alamofire.request(baseURL+URLS.JobBidsFinance_Upsert.rawValue, method: HTTPMethod.post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseObject { (response : DataResponse<JobBidFinanceAddModel>) in
            if let result = response.result.value {
                if result.IsValid {
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
    
    func callDeleteFinanceData(id : String,_ completionBLK:(( _ data :String?)->())?) {
        Alamofire.request(baseURL+URLS.JobBidsFinance_Delete.rawValue+id, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseString { (response : DataResponse<String>) in
            SVProgressHUD.dismiss()
            if let str = response.result.value {
                if completionBLK != nil {
                    completionBLK!(str.replacingOccurrences(of: "\"", with: ""))
                }
            }
        }
    }
}

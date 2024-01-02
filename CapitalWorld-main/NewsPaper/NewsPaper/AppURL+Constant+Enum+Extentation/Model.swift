
import EVReflection


let kUserInfo = "SavedUserInfo"
let kUserSecurity = "SavedUserSecurity"


class UserModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : UserInfo?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class UserInfo : EVObject {
    
    var Id = 0
    var FirstName = ""
    var PaymentPlanExpiryDateFrom = ""
    var PaymentPlanExpiryDateTo = ""
    var Name = ""
    var LastName = ""
    var PhoneNumber = ""
    var Email = ""
    var Password = ""
    var IsActive = 0
    var PaymentPlanId = 0
    var PaymentPlanName = ""
    var PaymentExpiryDate = ""
    var LastLogin = ""
    var DeviceTokens = ""
    var DeviceUDId = ""
    var IsFiestTimeLogin = false
    var OTP = ""
    var OS = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var LastLoginStr = ""
    var PaymentDateStr = ""
    var CountryId = ""
    var StateId = ""
    var CityId = ""
    var Country = ""
    var State = ""
    var City = ""
    var LanguageId = 0
    var IOSDisplayMessage = ""
    
    
    func save() {
        let defaults: UserDefaults = UserDefaults.standard
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
            defaults.set(data, forKey: kUserInfo)
            defaults.synchronize()
        }
        catch{ }
    }
    
    class func savedUser() -> UserInfo? {
        let defaults: UserDefaults = UserDefaults.standard
        let data = defaults.object(forKey: kUserInfo) as? Data
        if let data = data {
            do {
                if let userinfo = try  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) {
                    return userinfo as? UserInfo
                }
            }
            catch{}
        }
        return nil
    }
    
    class func clearUser() {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.removeObject(forKey: kUserInfo)
        defaults.synchronize()
    }
}

class PlanDataModel: EVObject {
    var TotalRecords = 0
    var Values = [PlanDataList]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = true
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class PlanDataList: EVObject {
    var Id = 0
    var PlanName = ""
    var Price = ""
    var ValidForDays = ""
}

class NotificationDataModel: EVObject {
    var TotalRecords = 0
    var Values = [NotificationDataList]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = true
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class NotificationDataList: EVObject {
    var Id = 0
    var CreatedBy = 0
    var UserId = 0
    var UserFirstName = ""
    var UserIds = ""
    var UserLastName = ""
    var UserEmail = ""
    var UserPhoneNumber = ""
    var UserPaymentExpiryDate = ""
    var NotificationText = ""
    var CreatedDate = ""
    var IsRead = false
    var AdminFullName = ""
    var AdminUserName = ""
    var CreatedDateStr = ""
}


class TransectionDataModel: EVObject {
    var TotalRecords = 0
    var Values = [PaymentUpsertData]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = true
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class PaperFileModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : PaperFileData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class PaperFileData: EVObject {
    var Id = 0
    var UploadedByName = 0
    var FileName = ""
    var FileUrl = ""
    var UploadedDate = ""
    var UploadedBy = 0
    var FireDate = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var DeletedDate = ""
    var DeletedBy = 0
    var Note = ""
    var UploadeName = ""
    var NewsPaperName = ""
    var FromNewsPaperDate = ""
    var ToNewsPaperDate = ""
    var FromPublishedDate = ""
    var ToPublishedDate = ""
    var ByDate = ""
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var DeletedDateStr = ""
    var UploadedDateStr = ""
    var FireDateStr = ""
}

class PaymentUpsertModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : PaymentUpsertData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class PaymentUpsertData: EVObject {
    var Id = 0
    var TransactionId = ""
    var UserId = 0
    var Time = ""
}

class CountryStateModel: EVObject {
    var TotalRecords = 0
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = true
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
    var Values = [CountryStateData]()
}

class CountryStateData: EVObject {
    var Id = 0
    var Name = ""
    var State = ""
    var Country = ""
    var City = ""
}


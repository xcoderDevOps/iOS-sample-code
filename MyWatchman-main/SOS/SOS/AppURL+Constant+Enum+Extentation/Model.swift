import EVReflection


let kUserInfo = "SavedUserInfo"
let kTokenInfo = "SavedUserToken"

class UserModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : UserInfo?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class UserListModel : EVObject {
    var TotalRecords = 0
    var Values = [UserInfo]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = false
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}


class UserInfo : EVObject {
    var Id = 0
    var CustomerId = 0
    var CountryId = 0
    var UserName = ""
    var IsCancel = false
    var ApprovedStatus = false
    var PlanId = 0
    var FirstName = ""
    var LastName = ""
    var Email = ""
    var Password = ""
    var ConfirmPassword = ""
    var Salt = ""
    var Mobile = ""
    var DeviceToken = ""
    var DeviceInfo = ""
    var CreatedBy = 0
    var CreatedDate = ""
    var ModifiedBy = 0
    var ModifiedDate = ""
    var DeletedBy = 0
    var DeletedDate = ""
    var FullName = ""
    var PlanName = ""
    var PlanPrice = 0
    var PlanDuration = 0
    var AddressCount = 0
    var PlanEndDate = ""
    var Otp = ""
    var ProfilePicture = ""
    var SecurityQuestionId = 0
    var Answer = ""
    var Price = ""
    var PlanExpiryDate = ""
    var PlanDurationMonth = 0
    var PlanCategory = ""
    var StartDate = ""
    var EndDate = ""
    var UserType = 0
    var ParentCustomer = 0
    var IsActive = false
    var AvatarFolder = ""
    var DocumentPath = ""
    var Path = ""
    var Age = ""
    var Gender = ""
    var BloodType = ""
    var PreExistingCondition = ""
    var AlergicMedicine = ""
    var HospitalName = ""
    var HospitalAddress = ""
    var DoctorName = ""
    var DoctorPhoneNumber = ""
    var InsuredBy = ""
    var InsuredThrough = ""
    var InsuranceId = 0
    var MedicalId = 0
    var MaxSubAccount = ""
    
    
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


class CountryListModel : EVObject {
    var TotalRecords = 0
    var Values = [CountryData]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = false
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class CountryData : EVObject {
    var Id = 0
    var Name = ""
    var CountryCode = ""
    var CreateDate = ""
    var ModifiedDate = ""
    var CreatedBy = 0
    var ModifiedBy = 0
}

class SecurityQuestionModel : EVObject {
    var TotalRecords = 0
    var Values = [SecurityQuestionData]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = false
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class SecurityQuestionData : EVObject {
    var Id = 0
    var Questions = ""
    var CreatedBy = 0
    var CreatedDate = ""
    var ModifiedBy = 0
    var ModifiedDate = ""
    var DeletedBy = 0
    var DeletedDate = ""
}


class AddressListModel : EVObject {
    var TotalRecords = 0
    var Values = [AddressListData]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = false
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class AddAddressModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : AddressListData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class AddressListData : EVObject {
    var Id = 0
    var CustomerId = 0
    var AddressName = ""
    var CustomerName = ""
    var Address = ""
    var Latitude = ""
    var Longitude = ""
    var CreatedBy = 0
    var CreatedDate = ""
    var ModifiedBy = 0
    var ModifiedDate = ""
    var DeletedBy = 0
    var DeletedDate = ""
}

class SOSHistoryListModel : EVObject {
    var TotalRecords = 0
    var Values = [SOSHistoryData]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = false
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class SOSHistoryModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : SOSHistoryData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class SOSHistoryData: EVObject {
    var Id = 0
    var CustomerId = 0
    var Address = ""
    var RoamingStaffId = 0
    var AddressName = ""
    var AddressId = 0
    var Note = ""
    var StartDate = ""
    var EndDate = ""
    var StartTime = ""
    var Status = 0
    var RoamingStaffName = ""
    var RoamingStaffPhone = ""
    var RoamingStaffPosition = ""
    var EndTime = ""
    var CompletedSOSInMin = ""
    var ValidOTP = 0
    var Latitude = ""
    var Longitude = ""
    var Rating = ""
    var Comment = ""
    var CreatedBy = 0
    var CreatedDate = ""
    var ModifiedBy = 0
    var ModifiedDate = ""
    var DeletedBy = 0
    var DeletedDate = ""
    var SOSTypeId = 0
    var RoamingStaffLat = ""
    var RoamingStaffLong = ""
    var RoamingStaffStartLat = ""
    var RoamingStaffStartLong = ""
    var UserName = ""
    var DeviceToken = ""
    var TypeName = ""
    var Mobile = ""
    var Email = ""
    var RoamingStaffRating = ""
    var CustomerRating = ""
    var RoamingStaffImageUrl = ""
    var CustomerProfilePicture = ""
    var AdminReason = ""
    var TimeAgo = ""
    var IsExists = 0
    var IsSOS = 0
    var ToRoamingStaffId = 0
    var SOSType = ""
    var SOSTypeShortName = ""
    var SOSTypeImage = ""
    var SOSTypeImageUrl = ""
    
}

class NotificationData : EVObject {
    var Id = 0
    var CustomerId = 0
    var RoamingStaffId = 0
    var Title = ""
    var Description = ""
    var CreatedBy = 0
    var CreatedDate = ""
    var ModifiedBy = 0
    var ModifiedDate = ""
    var DeletedBy = 0
    var DeletedDate = ""
    var DeviceToken = ""
    var UserDeviceToken = ""
    var FirstName = ""
    var CustomerFirstName = ""
    var LastName = ""
    var CustomerLastName = ""
    var Status = 0
    var SOSId = 0
    var SOSType = ""
    var ReadDateTime = ""
}

class NotificationListModel : EVObject {
    var TotalRecords = 0
    var Values = [NotificationData]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = false
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class ContactListModel : EVObject {
    var TotalRecords = 0
    var Values = [ContactData]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = false
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class ContactDataModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : ContactData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class ContactData : EVObject {
    var Id = 0
    var CustomerId = 0
    var CommunityCustomerId = 0
    var ApprovedStatus = false
    var ContactName = ""
    var ContactPhone = ""
    var ContactEmail = ""
    var Relation = ""
    var CreatedBy = 0
    var CreatedDate = ""
    var ModifiedBy = 0
    var ModifiedDate = ""
    var DeletedBy = 0
    var DeletedDate = ""
    var DeviceToken = ""
    var CountryId = ""
    var CountryCode = ""
}

class StatusMessageModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : AddressListData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}


class SOSTypeListModel : EVObject {
    var TotalRecords = 0
    var Values = [SOSTypeData]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = false
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class SOSTypeData : EVObject {
    var Id = 0
    var SOSCount = 0
    var `Type` = ""
    var Status = false
    var CreatedBy = 0
    var CreatedDate = ""
    var ModifiedBy = 0
    var ModifiedDate = ""
    var ImageUrlStr = ""
    var ShortName = ""
    var ImageUrl = ""
}

class SOSCompleteModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : SOSCompleteData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class SOSCompleteData: EVObject {
    var Id = 0
    var CustomerId = 0
    var SOSId = 0
    var Note = ""
    var Question = ""
    var Answer = ""
    var Other = ""
    var ImageUrl = ""
    var AdminReason = ""
    var SubmitDateTime = ""
    var CreatedBy = 0
    var CreatedDate = ""
    var ModifiedBy = 0
    var ModifiedDate = ""
    var DeletedBy = 0
    var DeletedDate = ""
    var AvatarFolder = ""
    var DocumentPath = ""
    var Path = ""
}

class RatingModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : RatingData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class RatingData : EVObject {
    var Id = 0
    var RoamingStaffId = 0
    var CustomerId = 0
    var SOSId = 0
    var Rating = 0
    var CreatedBy = 0
    var CreatedDate = ""
    var ModifiedBy = 0
    var ModifiedDate = ""
    var DeletedBy = 0
    var DeletedDate = ""
}


class PlanListModel : EVObject {
    var TotalRecords = 0
    var Values = [PlanListData]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = false
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class PlanDataModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : PlanListData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class PlanListData : EVObject {
    var Id = 0
    var PlanCategory = ""
    var ExpiryDate = ""
    var TransitionDate = ""
    var Price = ""
    var AddressCount = 0
    var SOSCount = 0
    var SOSType = ""
    var PlanDurationMonth = 0
    var TrialPeriod = 0
    var SubAccountCount = 0
    var CreatedBy = 0
    var CreatedDate = ""
    var ModifiedBy = 0
    var ModifiedDate = ""
    var DeletedBy = 0
    var DeletedDate = ""
    var DiscountPercentage = ""
    var Name = ""
    var PlanDetails = ""
}

class PlanDurationModel : EVObject {
    var TotalRecords = 0
    var Values = [PlanDurationData]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = false
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class PlanDurationData : EVObject {
    var Id = 0
    var Name = ""
    var DiscountPercentage = 0
    var CreatedBy = 0
    var CreatedDate = ""
    var ModifiedBy = 0
    var ModifiedDate = ""
    var DeletedBy = 0
    var DeletedDate = ""
}

class BillingListModel : EVObject {
    var TotalRecords = 0
    var Values = [BillingData]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = false
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class BillingData : EVObject {
    var Id = 0
    var CustomerId = 0
    var UserId = 0
    var PlanId = 0
    var IsCancel = false
    var TransactionAmount = 0
    var TransactionStartDate = ""
    var TransactionEndDate = ""
    var PlanName = ""
    var CreatedBy = 0
    var CreatedDate = ""
    var ModifiedBy = 0
    var ModifiedDate = ""
    var DeletedBy = 0
    var DeletedDate = ""
}

class TransectionModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : TransectionData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class TransectionData : EVObject {
    var Id = 0
    var CustomerId = 0
    var PlanId = 0
    var CardNumber = ""
    var CardCvv = ""
    var CardMonthYear = ""
    var Price = ""
    var TransitionDate = ""
    var ExpiryDate = ""
    var Mobile = ""
    var PlanCategory = ""
    var UserName = ""
    var PlanDurationMonth = 0
    var CreatedDate = ""
}

class StatasticListModel : EVObject {
    var TotalRecords = 0
    var Values = [StatasticData]()
    var Offset = 0
    var Limit = 0
    var IsOffsetProvided = false
    var Page = 0
    var PageSize = 0
    var SortBy = ""
    var TotalCount = 0
    var SortDirection = ""
    var IsPageProvided = false
}

class StatasticData: EVObject {
    var Id =  0
    var SOSCount =  0
    var `Type` =  ""
    var Status =  false
    var CreatedBy =  0
    var CreatedDate =  ""
    var ModifiedBy =  0
    var ModifiedDate =  ""
}

class InsuranceModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : InsuranceData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class InsuranceData: EVObject {
    var Id = 0
    var CustomerId = 0
    var HospitalName = ""
    var HospitalAddress = ""
    var DoctorName = ""
    var DoctorPhoneNumber = ""
    var InsuredBy = ""
    var InsuredThrough = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CustomerName = ""
    var CustomerEmail = ""
    var CustomerMobile = ""
}


class MedicalInfoModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : MedicalInfoData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class MedicalInfoData: EVObject {
    var Id = 0
    var CustomerId = 0
    var Age = ""
    var Gender = ""
    var BloodType = ""
    var PreExistingCondition = ""
    var AlergicMedicine = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CustomerName = ""
    var CustomerEmail = ""
    var CustomerMobile = ""
    var WeightLbs = "" {
        didSet {
            if WeightLbs.ns.doubleValue == 0.0 {
                WeightLbs = ""
            }
        }
    }
    var HeightFt = "" {
        didSet {
            if HeightFt.ns.doubleValue == 0.0 {
                HeightFt = ""
            }
        }
    }
    var HeightIn = "" {
        didSet {
            if HeightIn.ns.doubleValue == 0.0 {
                HeightIn = ""
            }
        }
    }
    
    var CurrentMedicationEnterHere1 = ""
    var CurrentMedicationEnterHere2 = ""
    var CurrentMedicationEnterHere3 = ""
    
}

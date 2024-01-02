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
    var Email = ""
    var Password = ""
    var IsApprovedByAdmin = false
    var IsActive = false
    var IsEmailVerified = false
    var IsMobileVerified = false
    var IsResetPassword = false
    var IsProfileCompleted = false
    var IsPlanActive = false
    var FirstName = ""
    var LastName = ""
    var IsCompany = false
    var CompanyName = ""
    var TradingLicense = ""
    var Tin = ""
    var RegistrantId = ""
    var CountryId = 0
    var PhoneNumber = ""
    var FactoringService = false
    var TruckTypeId = 0
    var LastLogin = ""
    var FileURL = ""
    var CountryCode = 0
    var MaximumTonage = ""
    var OldPassword = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var NewPassword = ""
    var Otp = ""
    var ConfirmPassword = ""
    var LoginType = false
    var `Type` = 0
    var ActiveJobs = 0
    var AmountEarned = 0
    var TotalDrivers = 0
    var TotalTrucks = 0
    var FullName = ""
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var LastLoginStr = ""
    var PhoneNumberStr = ""
    var FileUrlStr = ""
    var CommodityGroups = ""
    var isFindService = true
    var isProfileFeeled = false
    
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

class CountryModel : EVObject {
    var TotalRecords = ""
    var Values = [CountryData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class CountryData : EVObject {
    var Id = 0
    var Name = ""
    var CountryId = 0
    var CountryCode = ""
    var isSelect = false
}


class TruckTypeModel : EVObject {
    var TotalRecords = ""
    var Values = [TruckTypeData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class TruckTypeData : EVObject {
    var Id = 0
    var Name = ""
    var MaximumTonage = ""
    var Search = ""
}

class LocationTypeModel : EVObject {
    var TotalRecords = ""
    var Values = [LocationTypeData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class LocationTypeData : EVObject {
    var Id = 0
    var Name = ""
    var Search = ""
}

class ServiceTypeModel : EVObject {
    var TotalRecords = ""
    var Values = [ServiceTypeData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class ServiceTypeData : EVObject {
    var Id = 0
    var Name = ""
    var Search = ""
    var isSelect = false
    var ParentId = 0
}

class JobModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : JobData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class JobListModel : EVObject {
    var TotalRecords = ""
    var Values = [JobData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class JobData : EVObject {
    var Id = 0
    var ShipperId = 0
    var CarrierId = 0
    var DriverId = 0
    var TruckId = 0
    var Price = 0.0
    var JobBidId = 0
    var JobNo = ""
    var JobStatusId = 0
    var TruckTypeId = 0
    var TruckServiceId = 0
    var SubTruckServiceId = 0
    var NoOfContainer = 0
    var ActualTonage = 0
    var JobTonage = 0
    var TotalPallets = 0
    var ActualWeight = 0
    var JobWeight = 0
    var Cbm = 0
    var CommodityType = ""
    var HsCode = ""
    var PickUpShipperAddressId = 0
    var DropOffShipperAddressId = 0
    var SpecialMessage = ""
    var ExpressDate = ""
    var ShipperTentativeEndDate = ""
    var CarrierJobAssignedDate = ""
    var CarrierJobStartDate = ""
    var CarrierJobEndDate = ""
    var IsFargile = false
    var IsExpres = false
    var PickupDate = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var JobStatus = ""
    var TotalBids = 0
    var LowestBid = 0
    var HighestBid = 0
    var ShipperProfilePhoto = ""
    var ShipperProfilePhotoStr = ""
    var ShipperName = ""
    var ShipperEmail = ""
    var ShipperPhone = ""
    var ShipperCountryCode = ""
    var TruckType = ""
    var TruckService = ""
    var TruckSubService = ""
    var PickUpAddressLongitude = ""
    var PickUpAddressLatitude = ""
    var PickUpAddress = ""
    var DropOffAddress = ""
    var DropOffAddressLongitude = ""
    var DropOffAddressLatitude = ""
    var CarrierProfilePhoto = ""
    var CarrierProfilePhotoStr = ""
    var CarrierName = ""
    var CarrierEmail = ""
    var CarrierPhone = ""
    var CarrierCountryCode = ""
    var DriverProfilePhoto = ""
    var DriverProfilePhotoStr = ""
    var DriverName = ""
    var DriverEmail = ""
    var DriverPhone = ""
    var DriverCountryCode = ""
    var TruckPlate = ""
    var JobAmount = 0.0
    var CarrierEstDeliveryDate = ""
    var CarrierEstDeliveryDateStr = ""
    var CompanyName = ""
    var DriverLatitude = ""
    var DriverLongitude = ""
    var RatingToCarrier = 0
    var RatingToShipper = 0
    var CarrierAvgRating = 0
    var ShippperAvgRating = 0
    var CommentToShipper = ""
    var CommentToCarrier = ""
    var RatingToShipperDate = ""
    var RatingToCarrierDate = ""
    var Distance = 0.0
    var TruckLength = ""
    var UserTypeName = ""
    var ParentId = 0
    var ParentJobNo = ""
    var IsJobWithIssues = false
    var IsSamePath = false
    var CubicMeter = ""
    var Liters = ""
    var Cars = ""
    var Kg = ""
    var DeliveryItem = ""
    var IsCrossBorder = false
    var Currency = ""
    
}

class JobBidModel : EVObject {
    var TotalRecords = ""
    var Values = [JobBidData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class AddJobBidModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : JobBidData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class JobBidData : EVObject {
    var Id = 0
    var JobId = 0
    var CarrierId = 0
    var Price = 0.0
    var JobCompletionDays = 0
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var CarrierName = ""
    var CarrierPhoneNumber = ""
    var CarrierEmail = ""
    var CompanyName = ""
    var CarrierFileURL = ""
    var Description = ""
    var CarrierFileURLStr = ""
    var RatingToCarrier = ""
    var JobNumber = ""
    var JobCreatedDate = ""
    var JobCreatedDateStr = ""
    var IsFinance = false
    var Currency = ""
}

class JobDocModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : JobDocData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class JobDocData : EVObject {
    var Id = 0
    var JobId = 0
    var UserType = ""
    var DocumentTypeId = ""
    var Status = 0
    var Url = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
}

class DriverModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : DriverData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class DriverListModel : EVObject {
    var TotalRecords = ""
    var Values = [DriverData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class DriverData : EVObject {
    var Id = 0
    var Email = ""
    var Password = ""
    var IsActive = false
    var IsEmailVerified = false
    var IsMobileVerified = false
    var IsResetPassword = false
    var FirstName = ""
    var LastName = ""
    var FileURL = ""
    var EmployeerName = ""
    var DriverLicense = ""
    var DriverID = ""
    var CountryId = 0
    var CarrierId = 0
    var PhoneNumber = ""
    var LastLogin = ""
    var Otp = ""
    var CountryCode = 0
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var OldPassword = ""
    var NewPassword = ""
    var ConfirmPassword = ""
    var LoginType = false
    var `Type` = 0
    var FullName = ""
    var IsAvailable = false
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var LastLoginStr = ""
    var PhoneNumberStr = ""
    var FileUrlStr = ""
}

class TruckModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : TruckData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class TruckListModel : EVObject {
    var TotalRecords = ""
    var Values = [TruckData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class TruckData : EVObject {
    var Id = 0
    var IsActive = false
    var IsJobActive = false
    var PlateNumber = ""
    var CarrierId = 0
    var TruckTypeId = 0
    var Logbook = ""
    var CompanyName = ""
    var Insurance = ""
    var RfidTag = ""
    var LoadCapacity = 0
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var TruckTypeName = ""
    var IsAvailable = false
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var Imei = ""
    var IsMoving = 0
    var Latitude = ""
    var Longitude = ""
    var Speed = ""
    var FuelLevel = ""
}

class DocumentModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : DocumentData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class DocumentListModel : EVObject {
    var TotalRecords = ""
    var Values = [DocumentData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class DocumentData : EVObject {
    var Id = 0
    var ShipperId = 0
    var CarrierId = 0
    var DocumentType = ""
    var Url = ""
    var UrlStr = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var FileUrlStr = ""
}


class CommentModel : EVObject {
    var TotalRecords = ""
    var Values = [CommentData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class CommentData : EVObject {
    var Id = 0
    var JobId = 0
    var DriverId = 0
    var Comment = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var UserType = 0
}

class AddCommentModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : CommentData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class SelectedCountryListModel: EVObject {
    var TotalRecords = ""
    var Values = [ServiceTypeData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class AddServiceModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : ServiceTypeData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class PriceModel : EVObject {
    var TotalRecords = ""
    var Values = [PriceData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class PriceData : EVObject {
    var Id = ""
    var PlanName = ""
    var Description = ""
    var Price = ""
    var TimeLimit = ""
    var AdvPayPerc = ""
    var TotalNoOfInterServices = ""
    var AdditionalServicePrice = ""
    var IsActive = ""
    var UserType = ""
    var CreatedDate = ""
    var CreatedBy = ""
    var UpdatedDate = ""
    var UpdatedBy = ""
    var UserTypeName = ""
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
}

class PriceInsertModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : PriceInsertData?
    var IsValid = false
    var IsSuccessStatusCode =  false
}

class PriceInsertData : EVObject {
    var Id = ""
    var CarrierId = ""
    var MasterPricingPlanId = ""
    var StartDate = ""
    var EndDate = ""
    var CreatedDate = ""
    var UpdatedDate = ""
    var PlanName = ""
    var Description = ""
    var Price = ""
    var TimeLimit = ""
    var AdvPayPerc = ""
    var TotalNoOfInterServices = ""
    var AdditionalServicePrice = ""
    var IsActive = ""
    var UserType = ""
    var CreatedBy = ""
    var UpdatedBy = ""
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
}
class JobStatusActivityModel : EVObject {
    var TotalRecords = ""
    var Values = [JobStatusActivityData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class JobStatusActivityData : EVObject {
    var Id = 0
    var JobId = 0
    var UserType = 0
    var UserId = 0
    var CleanerId = 0
    var PreviousJobStatusId = 0
    var CurrentJobStatusId = 0
    var Note = ""
    var SystemNote = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var PreviousJobStatus = ""
    var CurrentJobStatus = ""
}


class JobLocationModel : EVObject {
    var TotalRecords = ""
    var Values = [JobLocationData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class JobLocationData : EVObject {
    var Id = 0
    var JobId = 0
    var DriverId = 0
    var Latitude = ""
    var Longitude = ""
    var CapturedDate = ""
    var CreatedDate = ""
    var CreatedDateStr = ""
}

class SupportModel : EVObject {
    var TotalRecords = ""
    var Values = [SupportData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class SupportData : EVObject {
    var Id = ""
    var CustomerId = ""
    var CleanerId = ""
    var JobId = ""
    var StatusId = ""
    var SupportNo = ""
    var Issue = ""
    var CustomerName = ""
    var CustomerEmail = ""
    var CustomerMobile = ""
    var CustomerProfile = ""
    var CleanerName = ""
    var CleanerEmail = ""
    var CleanerMobile = ""
    var CleanerProfile = ""
    var JobNumber = ""
    var Status = ""
    var CreatedDate = ""
    var CloseDate = ""
    var JobStatusId = ""
    var CreatedDateStr = ""
    var CloseDateStr = ""
}

class SupportChatModel : EVObject {
    var TotalRecords = ""
    var Values = [SupportChatData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class SupportChatData : EVObject {
    var Id = ""
    var SupportId = ""
    var ReplyText = ""
    var UserTypeId = ""
    var ReplyDate = ""
    var ReplyDateStr = ""
}

class SupportChatReplyModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : SupportChatData?
    var IsValid = false
    var IsSuccessStatusCode = false
}

class AddPaymentModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : PaymentData?
    var IsValid = false
    var IsSuccessStatusCode = false
}

class PaymentListModel: EVObject {
    var TotalRecords = ""
    var Values = [PaymentData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class PaymentData : EVObject {
    var Id = 0
    var JobId = 0
    var PaidByUserType = 0
    var Amount = 0
    var PaidToUserType = 0
    var `Type` = ""
    var Note = ""
    var PaymentDate = ""
    var Url = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var JobNumber = ""
    var PaymentFromUserType = ""
    var PaymentToUserType = ""
    var IsRecieved = false
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var UrlStr = ""
}

class RatingListModel: EVObject {
    var TotalRecords = ""
    var Values = [RatingData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class AddRatingModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : RatingData?
    var IsValid = false
    var IsSuccessStatusCode = false
}

class RatingData : EVObject {
    var Id = ""
    var JobId = ""
    var RatingToShipper = ""
    var CommentToShipper = ""
    var RatingToShipperDate = ""
    var RatingToCarrier = ""
    var CommentToCarrier = ""
    var RatingToCarrierDate = ""
    var IsActive = ""
    var `Type` = ""
    var ShipperId = ""
    var CarrierId = ""
    var CreatedDate = ""
    var CreatedBy = ""
    var UpdatedDate = ""
    var UpdatedBy = ""
    var UserType = ""
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var RatingToShipperDateStr = ""
}

class BillOfLoadingListModel: EVObject {
    var TotalRecords = ""
    var Values = [BillOfLoadingData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class AddBillOfLoadingModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : BillOfLoadingData?
    var IsValid = false
    var IsSuccessStatusCode = false
}

class BillOfLoadingData : EVObject {
    var Id = 0
    var JobId = 0
    var BillOfLoading = ""
    var FileUrl = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var FileUrlStr = ""
}

class AddTruckDriverCombo : EVObject {
    var Code = ""
    var Message = ""
    var Item : TruckDriverComboData?
    var IsValid = false
    var IsSuccessStatusCode = false
}

class TruckDriverComboList : EVObject {
    var TotalRecords = ""
    var Values = [TruckDriverComboData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class TruckDriverComboData : EVObject {
    var Id = 0
    var JobId = 0
    var TruckId = 0
    var DriverId = 0
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var DriverFirstName = ""
    var DriverLastName = ""
    var DriverEamil = ""
    var DriverPhoneNumber = ""
    var TruckPlateNumber = ""
    var TruckName = ""
    var DriverProfile = ""
    var DriverCountryCode = 0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var FileUrlStr = ""
}


class AddRootMasterAddress : EVObject {
    var Code = ""
    var Message = ""
    var Item : RouteData?
    var IsValid = false
    var IsSuccessStatusCode = false
}

class RouteModel : EVObject {
    var TotalRecords = ""
    var Values = [RouteData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class RouteData : EVObject {
    var Id = 0
    var JobId = 0
    var PickUpLocationName = ""
    var PickUpLat = ""
    var PickUpLong = ""
    var DropOffLocationName = ""
    var DropOffLat = ""
    var DropOffLong = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
}

class AddRootChieldAddress : EVObject {
    var Code = ""
    var Message = ""
    var Item : RouteDetailData?
    var IsValid = false
    var IsSuccessStatusCode = false
}

class RouteDetailModel : EVObject {
    var TotalRecords = ""
    var Values = [RouteDetailData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class RouteDetailData : EVObject {
    var Id = 0
    var RouteMasterId = 0
    var LocationName = ""
    var Lat = ""
    var Long = ""
    var IsPassed = false
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
}

class TransectionHistoryModel : EVObject {
    var TotalRecords = ""
    var Values = [TransectionHistoryData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class TransectionHistoryData : EVObject {
    var Id = 0
    var JobId = 0
    var PaidByUserType = 0.0
    var Amount = 0
    var PaidToUserType = 0
    var `Type` = ""
    var Note = ""
    var PaymentDate = ""
    var Url = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var JobNumber = ""
    var PaymentFromUserType = ""
    var PaymentToUserType = ""
    var IsRecieved = false
    var FromDate = ""
    var ToDate = ""
    var IsPaymentExists = false
    var JobNo = ""
    var ShipperName = ""
    var ShipperEmail = ""
    var ShipperPhoneNumber = ""
    var CarrierPhoneNumber = ""
    var CarrierName = ""
    var CarrierEmail = ""
    var PaidByUserTypeName = ""
    var PaidToUserTypeName = ""
    var AmountPending = 0.0
    var Price = 0.0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
    var UrlStr = ""
}

class NotificationListModel : EVObject {
    var TotalRecords = ""
    var Values = [NotificationData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class NotificationData : EVObject {
    var Id = 0
    var UserId = 0
    var UserType = 0
    var Text = ""
    var UserTypeName = ""
    var IsRead = ""
    var NotRead = ""
    var CarrierPlaceId = 0
    var TruckId = 0
    var IsMoving = 0
    var CreatedDate = ""
    var CreatedDateStr = ""
}

class ReadNotificationModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : ReadNotificationItem?
    var IsValid = false
    var IsSuccessStatusCode = false
}

class ReadNotificationItem : EVObject {
        var Id = 0
        var UserId = 0
        var UserType = 0
        var Text = ""
        var UserTypeName = ""
        var IsRead = false
        var NotRead = 0
        var CreatedDate = ""
        var CreatedDateStr = ""
}


class TruckFualModel : EVObject {
    var TotalRecords = ""
    var Values = [TruckFualData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class TruckFualData : EVObject {
    var Id = 0
    var TruckId = 0
    var JobId = 0
    var JobTruckDriversId = 0
    var Imei = ""
    var JobNo = ""
    var DriverName = ""
    var TruckPlatNo = ""
    var TruckType = ""
    var Lat = ""
    var Long = ""
    var Speed = ""
    var Fuel = ""
    var CapturedDate = ""
    var CreatedDate = ""
    var CreatedDateStr = ""
    var TruckLocationId = 0
    var TruckFuelId = 0
    var Voltage = ""
}


class FualTypeModel : EVObject {
    var TotalRecords = ""
    var Values = [FualTypeData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class AddFualTypeModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : FualTypeData?
    var IsValid = false
    var IsSuccessStatusCode = false
}

class FualTypeData : EVObject {
    var Id = 0
    var TruckId = 0
    var FuelMasterId = 0
    var FuelType = ""
    var Formula = ""
    var CreatedDate = ""
    var UpdatedDate = ""
}

class MyPlaceListModel: EVObject {
    var TotalRecords = ""
    var Values = [MyPlaceData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class MyPlaceModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : MyPlaceData?
    var IsValid = false
    var IsSuccessStatusCode = false
}


class MyPlaceData: EVObject {
    var Id = 0
    var CarrierId = 0
    var Name = ""
    var Lat = ""
    var Long = ""
    var Description = ""
    var ContactNumber = ""
    var FullName = ""
    var CreatedDate = ""
    var CreatedBy = 0
    var UpdatedDate = ""
    var UpdatedBy = 0
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
}

class JobBidFinanceListModel : EVObject {
    var TotalRecords = ""
    var Values = [JobBidFinanceData]()
    var Offset = ""
    var Limit = ""
    var IsOffsetProvided = ""
    var Page = ""
    var PageSize = ""
    var SortBy = ""
    var TotalCount = ""
    var SortDirection = ""
    var IsPageProvided = ""
}

class JobBidFinanceAddModel : EVObject {
    var Code = ""
    var Message = ""
    var Item : JobBidFinanceData?
    var IsValid = false
    var IsSuccessStatusCode = false
}

class JobBidFinanceData: EVObject {
    var Id = 0
    var JobBidId = 0
    var FinanceType = ""
    var Percentage = 0
    var Days = 0
    var CreatedDate = ""
    var UpdatedDate = ""
    var CarrierName = ""
    var JobNumber = ""
    var CreatedDateStr = ""
    var UpdatedDateStr = ""
}

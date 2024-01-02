//
//  AppURL.swift
//  iCognizance
//
//  Created by MickyBahu on 22/01/19.
//  Copyright © 2019 InfoLabh. All rights reserved.
//

import Foundation

let GooglePlaceKey  = "AIzaSyABofRnRkpT_4m344ZOsyRnT90uSGF5H6A"
//Way: "AIzaSyD0TeiEcoX6AQEo9oDsrYcnB_St1g4WCvQ"

//var baseURL = "http://cargoxpressapi.lamproskids.com/api/"
var baseURL = "http://api.auroratechafrica.com/api/"

var imgBaseUrl = "http://admin.auroratechafrica.com/"


enum URLS : String {
    case adminOtp                   =   "admin/SendSms?countrymobile="
    case countryAll                 =   "countries/Countries_All"
    case CarrierSignup              =   "carrier/Carriers_Upsert"
    case Carriers_Login             =   "carrier/Carriers_Login"
    case CarrierLogout              =   "carrier/Carriers_Logout"
    case Carriers_ById              =   "carrier/Carriers_ById?Id="
    case CarrierDocuments_Upsert    =   "carrierDocuments/CarrierDocuments_Upsert"
    case Carriers_ProfileUpdate     =   "carrier/Carriers_ProfileUpdate"
    case CarrierDocuments_All       =   "carrierDocuments/CarrierDocuments_All?CarrierId="
    case Carriers_ChangePassword    =   "carrier/Carriers_ChangePassword"
    case CarrierDestinations_Upsert = "carrierPreferedDestinations/CarrierPreferedDestinations_Upsert"
    case CarrierPreferedDestinations_All = "carrierPreferedDestinations/CarrierPreferedDestinations_All?CarrierId="
    case CarrierTruckServices_Upsert    = "carrierTruckServices/CarrierTruckServices_Upsert"
    case ShipperSignup              =   "shipper/ShipperUpsert"
    case ShipperLogin               =   "shipper/ShipperLogin"
    case ShipperLogout              =   "shipper/Shippers_Logout?Id="
    case Shippers_ById              =   "shipper/Shippers_ById?Id="
    case ShipperDocuments_Upsert    =   "shipperDocuments/ShipperDocuments_Upsert"
    case Shippers_ProfileUpdate     =   "shipper/Shippers_ProfileUpdate"
    case ShipperDocuments_ById      =   "shipperDocuments/ShipperDocuments_All?ShipperId="
    case Shippers_ChangePassword    =   "shipper/Shippers_ChangePassword"
    
    case ShipperVerifyMobileNo      =   "shipper/Shipper_VerifyMobileNoForJob"
    
    case LocationTypes_All          =   "locationTypes/LocationTypes_All"
    case TruckTypes_All             =   "truckTypes/TruckTypes_All"
    case TruckServices_All          =   "truckServices/TruckServices_All?ParentId="
    case TruckDocuments_Upsert      =   "truckDocuments/TruckDocuments_Upsert"
    case TruckDocuments_All         =   "truckDocuments/TruckDocuments_All?CarrierId="
    case Trucks_ActInact            =   "trucks/Trucks_ActInact?Id="
    
    case Job_All                    =   "job/Job_All?"
    case Job_Insert                 =   "job/Job_Upsert"
    case PostBid                    =   "jobBids/JobBids_Upsert"
    case JobBids_ByJobId            =   "jobBids/JobBids_ByJobId?"
    case Job_AcceptBid              =   "job/Job_AcceptBid"
    case JobDocuments_Upsert        =   "jobDocuments/JobDocuments_Upsert"
    case JobDocuments_ByJobId       =   "JobDocuments_ByJobId?"
    
    case JobStart                   =   "job/Job_CarrierJobStartDate"
    case JobEnd                     =   "job/Job_CarrierJobEndDate"
    case Job_JobStatus              =   "job/Job_JobStatus"
    case Job_AssignDriver           =   "job/Job_AssignDriver"
    case Job_AssignTruck            =   "job/Job_AssignTruck"
    case Job_ById                   =   "job/Job_ById?Id="
    case Job_Activity               =   "job/Job_Activity?JobId="
    case jobTrackLocation           =   "jobDriverLocation/JobDriverLocation_ByJobId?JobId="
    
    case Drivers_Upsert             =   "drivers/Drivers_Upsert"
    case JobTruckDrivers_ByJobId    =   "jobTruckDrivers/JobTruckDrivers_ByJobId?JobId="
    case Drivers_All                =   "drivers/Drivers_All?CarrierId="
    case JobTruckDrivers_Delete     =   "jobTruckDrivers/JobTruckDrivers_Delete?Id="
    case JobTruckDrivers_Upsert     =   "jobTruckDrivers/JobTruckDrivers_Upsert"
    
    case Trucks_Upsert              =   "trucks/Trucks_Upsert"
    case Truck_All                  =   "trucks/Trucks_All?CarrierId="
    
    case JobDriverComments_All      =   "jobDriverComments/JobDriverComments_All?"
    case JobDriverComments_Upsert   =   "jobDriverComments/JobDriverComments_Upsert"
    
    case RouteMaster_ByJobId        =   "routeMaster/RouteMaster_ByJobId?JobId="
    case RouteChild_ByRouteMasterId =   "routeChild/RouteChild_ByRouteMasterId?RouteMasterId="
    
    case MasterPricingPlans_All     =   "masterPricingPlans/MasterPricingPlans_All?UserType="
    case CarrierPricingPlan_Upsert  =   "carrier/CarrierPricingPlan_Upsert"
    
    case AddTicket                  =   "support/Support_Upsert"
    case SupportAll                 =   "support/Support_All?"
    case SupportChat                =   "supportReply/SupportReply_BySupportId?SupportId="
    case SupportChatReply           =   "supportReply/SupportReply_Upsert"
    case Support_Close              =   "support/Support_Close?Id="
    
    case PaymentMaster_Upsert       =   "paymentMaster/PaymentMaster_Upsert"
    case PaymentMaster_All          =   "paymentMaster/PaymentMaster_All?"
    
    case JobRatingUpsert            =   "jobRatings/JobRatingsUpsert"
    case JobRatingListing           =   "jobRatings/JobRatings_ByJobId?JobId="
    case JobBillOfLoading_Upsert    =   "jobBillOfLoading/JobBillOfLoading_Upsert"
    case JobBillOfLoading_All       =   "jobBillOfLoading/JobBillOfLoading_All?JobId="
    case JobBillOfLoading_Delete    =   "jobBillOfLoading/JobBillOfLoading_Delete?Id="
    case RouteMaster_Upsert         =   "routeMaster/RouteMaster_Upsert"
    case RouteChild_Upsert          =   "routeChild/RouteChild_Upsert"
    
    case JobBidsFinance_All         =   "jobBidsFinance/JobBidsFinance_All?JobBidId="
    case JobBidsFinance_Upsert      =   "jobBidsFinance/JobBidsFinance_Upsert"
    case JobBidsFinance_Delete      =   "jobBidsFinance/JobBidsFinance_Delete?Id="
    
    case TransactionReport_ADVANCED =   "paymentMaster/TransactionReport_ADVANCED?"
    
    case Notification_Count         =   "notification/Notification_Count"
    case Notification_All           =   "notification/Notification_All?UserId="
    case NotificationByPlaceId      =   "notification/Notification_AllByCarrierPlacesId?CarrierPlaceId="
    case Notification_IsReadUpdate  =   "notification/Notification_IsReadUpdate"
    
    case TruckLocationFuel_All      =   "truckLocation/TruckLocationFuel_All"
    case TruckLocation_All          =   "truckLocation/TruckLocation_All"
    case FuelMaster_All             =   "fuelMaster/FuelMaster_All"
    case TruckFuel_Delete           =   "truckFuel/TruckFuel_Delete?Id="
    case TruckFuel_All              =   "truckFuel/TruckFuel_All?TruckId="
    case TruckFuel_Upsert           =   "truckFuel/TruckFuel_Upsert"
    case CarrierPlaces_All          =   "carrierPlaces/CarrierPlaces_All?CarrierId="
    case CarrierPlaces_Delete       =   "carrierPlaces/CarrierPlaces_Delete?Id="
    case CarrierPlaces_Upsert       =   "carrierPlaces/CarrierPlaces_Upsert"
}

